#!/usr/bin/env bash

################################################################################
# This script runs somalier extract on the input BAM file
# to extract sites and genotypes for the sample.
################################################################################

# Arguments and variables
input_bam=$1
variant_sites_vcf=$2
reference_fasta=$3

# Run somalier extract
somalier extract --sites $variant_sites_vcf -f $reference_fasta $input_bam || exit 1
