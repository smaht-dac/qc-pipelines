#!/usr/bin/env bash

################################################################################
# This script calculates relatedness between samples by running somalier 
# relate function on a specified set of .somalier files.
################################################################################

# Arguments and variables
output_prefix=$1
shift 1  # Shift arguments so $@ contains only the .somalier files

# Check if the required arguments are provided
if [ -z "$output_prefix" ] || [ "$#" -eq 0 ]; then
    echo "Usage: $0 <output_prefix> [file.somalier ...]"
    exit 1
fi

# Link input files in the working directory
for file in $@; do
    basename=$(basename $file)
    ln -s $file $basename
done

# Run somalier relate
somalier relate -o $output_prefix *.somalier || exit 1
