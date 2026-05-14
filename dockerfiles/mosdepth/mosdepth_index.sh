#!/usr/bin/env bash

################################################################################
# This script indexes the input BAM file and then runs mosdepth.
################################################################################

# Arguments and variables
input_bam=$1
nthreads=$2
output_prefix=$3

# Symlink BAM into work directory so samtools can write the index alongside it
bam_name=$(basename ${input_bam})
ln -s ${input_bam} ${bam_name} || exit 1

# Index the BAM file
samtools index -@ ${nthreads} ${bam_name} || exit 1

# Run mosdepth
mosdepth -n --fast-mode -t ${nthreads} ${output_prefix} ${bam_name} || exit 1
