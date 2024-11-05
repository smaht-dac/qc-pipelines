#!/usr/bin/env bash

################################################################################
# This script calculates relatedness between samples by running somalier 
# relate function on a specified set of .somalier files.
################################################################################

# Arguments and variables
threshold=$1
output_prefix=$2
shift 2  # Shift arguments so $@ contains only the .somalier files

# Check if the required arguments are provided
if [ -z "$threshold" ] || [ -z "$output_prefix" ] || [ "$#" -eq 0 ]; then
    echo "Usage: $0 <threshold> <output_prefix> [file.somalier ...]"
    exit 1
fi

# Link input files in the working directory
for file in $@; do
    basename=$(basename $file)
    ln -s $file $basename
done

# Run somalier relate
somalier relate -o $output_prefix *.somalier || exit 1

# Check output
py_script="
import sys, os

try:
    threshold = float('${threshold}')
except ValueError:
    sys.exit('Error: Threshold must be a number.')

passed, failed = [], []

with open('${output_prefix}.pairs.tsv', 'r') as f:
    for line in f:
        if line.startswith('#'):
            continue
        sample_a, sample_b, relatedness = line.rstrip().split('\t')[:3]
        relatedness = float(relatedness)
        if relatedness >= threshold:
            passed.append((sample_a, sample_b, relatedness))
        else:
            failed.append((sample_a, sample_b, relatedness))

# Print results
if passed:
    print('-> Passed samples:')
    for sample_a, sample_b, relatedness in passed:
        print(f'{sample_a} - {sample_b} --> {relatedness}')

# Exit with a message if there are any failed samples
if failed:
    print('-> Failed samples:')
    for sample_a, sample_b, relatedness in failed:
        print(f'{sample_a} - {sample_b} --> {relatedness}')
    
    os.remove('${output_prefix}.pairs.tsv')
    sys.exit('Failed samples identity check!')
"

python -c "$py_script" || exit 1
