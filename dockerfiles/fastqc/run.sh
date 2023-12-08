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

# Add other metrics to summary.txt
# Get metrics
total_sequences=$(grep "Total Sequences" ${base}_fastqc/fastqc_data.txt | cut -f 2)
sequence_length=$(grep "Sequence length" ${base}_fastqc/fastqc_data.txt | cut -f 2)

# Append metrics
echo -e "${total_sequences}\tTotal Sequences\t." >> summary.txt
echo -e "${sequence_length}\tSequence Length\t." >> summary.txt
