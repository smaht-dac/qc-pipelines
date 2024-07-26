#!/usr/bin/env bash

################################################################################
# This script runs Kraken2 on a single-end FASTQ file or paired-end FASTQ files
# It returns the Kraken2 report, not the read-level classification
################################################################################

# Function to display help message
show_help() {
    echo "Usage: $0 -i input.fastq.gz [-j input_r2.fastq.gz] -d database [-t threads] [-h]"
    echo ""
    echo "Arguments:"
    echo "  -i         Input FASTQ file (R1 if paired-end)"
    echo "  -j         Input FASTQ file (R2)"
    echo "  -d         Kraken2 database"
    echo "  -t         Number of threads"
    echo "  -h         Show this help message"
}

# Variables
input_file_fastq_r1=""
input_file_fastq_r2=""
database=""
nthreads=1

# Parse command-line arguments using getopts
while getopts 'i:j:d:t:h' opt; do
    case $opt in
        i) input_file_fastq_r1="$OPTARG" ;;
        j) input_file_fastq_r2="$OPTARG" ;;
        d) database="$OPTARG" ;;
        t) nthreads="$OPTARG" ;;
        h) show_help ; exit 0 ;;
        *) show_help ; exit 1 ;;
    esac
done

# Check for required arguments
if [ -z "$input_file_fastq_r1" ]; then
    echo "Missing required argument: input FASTQ file"
    show_help
    exit 1
fi

if [ -z "$database" ]; then
    echo "Missing Kraken2 database"
    show_help
    exit 1
fi


mkdir db
# Extract database file to folder "db"
tar -xvzf $database -C db

# If an R2 FASTQ file is provided, run Kraken in paired mode
if [ -z "$input_file_fastq_r2" ]; then
    echo "Running Kraken2 in single mode."
    kraken2 --threads $nthreads --use-names \
        --db db \
        --report kraken2_report.txt \
        $input_file_fastq_r1 > /dev/null
else
    echo "Running Kraken2 in paired mode."
    kraken2 --threads $nthreads --paired --use-names \
        --db db \
        --report kraken2_report.txt \
        $input_file_fastq_r1 \
        $input_file_fastq_r2 > /dev/null
fi
