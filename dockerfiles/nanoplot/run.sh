#!/usr/bin/env bash

## Variables
input_file=$1
# could be FASTQ or unmapped BAM (uBAM)

nt=$(nproc) # number of threads to use in computation,
            # set to number of cores in the server

###################################################
# Assign correct flag
#   this can be --fastq or --ubam
###################################################
# Get the file extension
filename=$(basename -- $input_file)
extension=${filename#*.}

# Initialize the flag variable
flag=""

# Check the file extension and set the flag accordingly
if [[ "$extension" == "bam" ]]; then
    flag="--ubam"
elif [[ "$extension" == "fastq.gz" ]]; then
    flag="--fastq"
else
    echo "Unsupported file extension."
    exit 1
fi

# Create local symlink to input_file where NanoPlot has write permission
#   NanoPlot will try to write a local index for input_file
ln -s $input_file input_file.${extension}

###################################################
# Run
###################################################
echo "Using ${flag}"
NanoPlot -t $nt --N50 $flag input_file.${extension} -o . || exit 1

# This will generate the following files
#   NanoStats.txt                     <---
#   NanoPlot-report.html              <---
#   WeightedHistogramReadlength.html
#   WeightedHistogramReadlength.png
#   WeightedLogTransformed_HistogramReadlength.html
#   WeightedLogTransformed_HistogramReadlength.png
#   Non_weightedHistogramReadlength.html
#   Non_weightedHistogramReadlength.png
#   Non_weightedLogTransformed_HistogramReadlength.html
#   Non_weightedLogTransformed_HistogramReadlength.png
#   Yield_By_Length.html
#   Yield_By_Length.png
#   LengthvsQualityScatterPlot_dot.html
#   LengthvsQualityScatterPlot_dot.png
#   LengthvsQualityScatterPlot_kde.html
#   LengthvsQualityScatterPlot_kde.png
