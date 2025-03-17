#!/bin/bash

################################################################################
# This script runs Samtools mpileup on a BAM file for a list of regions.
# It requires Samtools to be installed in the system.
#
# Regions are read from a file, one region per line.
# The script runs mpileup in parallel for each region and merges the results.
################################################################################

# Usage function
usage() {
    echo "Usage: $0 -r <reference.fa> -b <input.bam> -l <regions_file> [-o <output_prefix>] [-f <samtools_flags>]"
    exit 1
}

# Default values
OUTPUT_PREFIX="out"
SAMTOOLS_FLAGS="-B -a -s -q 1"  # Default flags
                                # -B: disable BAQ computation
                                # -a: output all positions (including those with zero depth)
                                # -s: output base alignment quality
                                # -q: minimum alignment quality

nt=$(nproc)  # Number of threads (set to available cores)

# Parse command-line arguments
while getopts "r:b:l:o:f:" opt; do
    case $opt in
        r) REFERENCE_FASTA="$OPTARG" ;;
        b) INPUT_BAM="$OPTARG" ;;
        l) REGIONS_FILE="$OPTARG" ;;
        o) OUTPUT_PREFIX="$OPTARG" ;;
        f) SAMTOOLS_FLAGS="$OPTARG" ;;  # Custom samtools flags
        *) usage ;;
    esac
done

# Check required arguments
if [[ -z "$REFERENCE_FASTA" || -z "$INPUT_BAM" || -z "$REGIONS_FILE" ]]; then
    usage
fi

# Run mpileup in parallel
echo "Running mpileup..."
xargs -P $nt -I {} bash -c "samtools mpileup $SAMTOOLS_FLAGS -r {} -f $REFERENCE_FASTA -o ${OUTPUT_PREFIX}_{}.mpileup $INPUT_BAM" < $REGIONS_FILE || exit 1

# Collect mpileup files
echo "Merging mpileup files..."
mpileup_files=(${OUTPUT_PREFIX}_*.mpileup)

# Sort mpileup files
IFS=$'\n' sorted_files=($(sort -V <<<"${mpileup_files[*]}"))
unset IFS

# Merge mpileup files
for filename in ${sorted_files[@]}; do
    if [[ "$filename" =~ (M\.mpileup)$ ]]; then
        chr_M=$filename
    else
        cat $filename >> ${OUTPUT_PREFIX}.txt || exit 1
        rm -f $filename
    fi
done

if [[ -v "$chr_M" ]]; then
    cat $chr_M >> ${OUTPUT_PREFIX}.txt || exit 1
    rm -f $chr_M
fi

echo "Processing completed! Output: ${OUTPUT_PREFIX}.txt"
