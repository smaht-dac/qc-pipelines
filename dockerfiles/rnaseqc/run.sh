#!/usr/bin/env bash

# Variables
rnaseqc_tar_gz=$1
sample=$2

# Exctract the metrics files
tar -xvzf $rnaseqc_tar_gz

# Create metrics JSON
python collect_rnaseqc_metrics.py -m . -s $sample -o metrics.json || exit 1
