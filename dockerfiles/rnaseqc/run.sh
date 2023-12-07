#!/bin/bash

# Variables
input_bam=$1
gtf_collapsed=$2

# The -s paramter will produce output files of the form sample.*, e.g., sample.coverage.tsv
./rnaseqc $gtf_collapsed $input_bam rnaseqc_output_dir -s sample --coverage || exit 1

# Compress all output. This can be downloaded from the portal
tar -zcf rnaseqc_output.tar.gz ./rnaseqc_output_dir/ || exit 1

# Create metrics JSON
python collect_rnaseqc_metrics.py -m /usr/local/bin/rnaseqc_output_dir/ -s sample -o metrics.json || exit 1
