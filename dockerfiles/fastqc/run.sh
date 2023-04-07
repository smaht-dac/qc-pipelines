#!/bin/bash

# Variables
input_file_fastq=$1
nthreads=$2

# Run FastQC
fastqc --threads $nthreads $input_file_fastq
