#!/bin/bash

# Variables
input_bam=$1
genome_size=$2


# Run bamstats
python bamStats.py -b $input_bam -g $genome_size -o out.txt
