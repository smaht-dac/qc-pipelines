#!/usr/bin/env bash

################################################################################
# This script subsamples a BAM file to a desired fraction or a desired coverage.
# The script requires Samtools to be installed in the system.
#
# If desired coverage is specified, the script requires a Samtools stats file for the input BAM file.
# This file is used to estimate coverage and calculate the subsampling fraction needed to achieve the desired coverage.
################################################################################

# Function to display help message
show_help() {
    echo "Usage: $0 -i input.bam [-s seed] [-t threads] [-o output_prefix] [-g genome_size] -r fraction | -c coverage -l samtools.stats [-h]"
    echo ""
    echo "Arguments:"
    echo "  -i         Input BAM file"
    echo "  -s         Seed for subsampling [0]"
    echo "  -t         Number of extra threads for compression/decompression [0]"
    echo "  -o         Output file prefix [output]"
    echo "  -g         Genome size [2913022398]"
    echo "  -r         Desired subsampling fraction (mutually exclusive with -l and -c)"
    echo "  -c         Desired coverage (mutually exclusive with -r)"
    echo "  -l         Corresponding Samtools stats output file (used with -c to calculate subsampling fraction)"
    echo "  -h         Show this help message"
}

# Initialize variables
input_file_bam=""
seed=0
nthreads=0
output_prefix="output"
genome_size=2913022398
fraction=""
desired_coverage=""
samtools_stats=""

# Parse command-line arguments using getopts
while getopts 'i:s:t:o:g:r:l:c:h' opt; do
    case $opt in
        i) input_file_bam="$OPTARG" ;;
        s) seed="$OPTARG" ;;
        t) nthreads="$OPTARG" ;;
        o) output_prefix="$OPTARG" ;;
        g) genome_size="$OPTARG" ;;
        r) fraction="$OPTARG" ;;
        c) desired_coverage="$OPTARG" ;;
        l) samtools_stats="$OPTARG" ;;
        h) show_help ; exit 0 ;;
        *) show_help ; exit 1 ;;
    esac
done

# Check for required arguments
if [ -z "$input_file_bam" ]; then
    echo "Missing required argument: input BAM file"
    show_help
    exit 1
fi

if [ -n "$fraction" ] && ([ -n "$samtools_stats" ] || [ -n "$desired_coverage" ]); then
    echo "Options -r and -l/-c are mutually exclusive"
    show_help
    exit 1
fi

if [ -n "$samtools_stats" ] && [ -z "$desired_coverage" ]; then
    echo "When using -l, you must also provide -c"
    show_help
    exit 1
fi

if [ -n "$desired_coverage" ] && [ -z "$samtools_stats" ]; then
    echo "When using -c, you must also provide -l"
    show_help
    exit 1
fi

if [ -z "$fraction" ] && ([ -z "$samtools_stats" ] || [ -z "$desired_coverage" ]); then
    echo "You must provide either -r (fraction) or both -l (stats file) and -c (coverage)"
    show_help
    exit 1
fi

# Function to calculate coverage and adjust the subsampling fraction
calculate_subsample_ratio() {
    local aligned_bases=$(grep "bases mapped:" $samtools_stats | awk '{print $4}')
    local current_coverage=$(echo "$aligned_bases / $genome_size" | bc -l)
    local adjusted_fraction=$(echo "$desired_coverage / $current_coverage" | bc -l)
    printf "%.6f\n%.6f" "$current_coverage" "$adjusted_fraction"
}

# Adjust the subsampling fraction when desired coverage is specified
if [[ -n $samtools_stats ]]; then
    coverage_fraction=$(calculate_subsample_ratio)
    current_coverage=$(echo $coverage_fraction | cut -d' ' -f1)
    fraction=$(echo $coverage_fraction | cut -d' ' -f2)
    echo "Estimated coverage: $current_coverage"
    echo "Calculated subsample fraction: $fraction"
fi

# Check if the subsampling fraction is greater than 1 and set it to 1 if it is
if (( $(echo "$fraction > 1" | bc -l) )); then
    echo "Warning: Subsample fraction should be between 0 and 1. Setting fraction to 1"
    fraction=1
fi

# Echo the command for debugging and log
echo "samtools view -@ $nthreads -hb --subsample $fraction --subsample-seed $seed $input_file_bam > ${output_prefix}.bam"

# Subsample the BAM file
samtools view -@ $nthreads -hb --subsample $fraction --subsample-seed $seed $input_file_bam > ${output_prefix}.bam || exit 1

# Index the BAM file
samtools index -@ $nthreads ${output_prefix}.bam || exit 1

# Check integrity of the BAM file
py_script="
import sys, os

def check_EOF(filename):
    EOF_hex = b'\x1f\x8b\x08\x04\x00\x00\x00\x00\x00\xff\x06\x00\x42\x43\x02\x00\x1b\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    size = os.path.getsize(filename)
    fb = open(filename, 'rb')
    fb.seek(size - 28)
    EOF = fb.read(28)
    fb.close()
    if EOF != EOF_hex:
        sys.stderr.write('EOF is missing\n')
        sys.exit(1)
    else:
        sys.stderr.write('EOF is present\n')

check_EOF('${output_prefix}.bam')
"

python -c "$py_script" || exit 1