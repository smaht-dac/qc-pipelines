#!/bin/bash

# Variables
input_file_fastq=$1
nthreads=$2
output_directory_name=$3

# Create directory for output
mkdir -p $output_directory_name

# Run FastQC
fastqc --threads $nthreads -o $output_directory_name $input_file_fastq
