#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -i input.bam [-o prefix] [-t threads] [-h]

  -i   Input BAM file (required)
  -o   Output file prefix (default: output)
  -t   Threads (default: number of cores on machine)
  -h   Help
EOF
  exit 1
}

# Defaults
INPUT_BAM=""
OUTPUT_PREFIX="output"
NTHREADS="$(nproc)"

## Command line arguments
while getopts ":i:o:t:h" opt; do
  case $opt in
    i) INPUT_BAM="$OPTARG" ;;
    o) OUTPUT_PREFIX="$OPTARG" ;;
    t) NTHREADS="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

# Check required arguments
[[ -n "$INPUT_BAM" ]] || usage

# File checks
[[ -f "$INPUT_BAM" ]] || { echo "Error: $INPUT_BAM not found"; exit 1; }


# Symlink BAM into work directory so samtools can write the index alongside it
bam_name=$(basename ${INPUT_BAM})
ln -s ${INPUT_BAM} ${bam_name} || exit 1

# Index the BAM file
samtools index -@ ${NTHREADS} ${bam_name} || { echo "Error: samtools index failed"; exit 1; }

# Run mosdepth
mosdepth -n --fast-mode -t ${NTHREADS} ${OUTPUT_PREFIX} ${bam_name} || { echo "Error: mosdepth failed"; exit 1; }
