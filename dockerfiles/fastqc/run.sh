#!/bin/bash

# Variables
input_file_fastq=$1
nthreads=$2

# Run FastQC
fastqc --threads $nthreads -o . $input_file_fastq || exit 1

# Prepare output
base=$(basename "$input_file_fastq" .fastq.gz)

unzip ${base}_fastqc.zip
mv ${base}_fastqc/summary.txt .
