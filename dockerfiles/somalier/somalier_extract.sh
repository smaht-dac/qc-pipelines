#!/usr/bin/env bash
set -euo pipefail

################################################################################
# Replace SAMPLE across the @RG definitions of the input BAM file, then run
# somalier extract on the reheadered file to extract sites and genotypes for
# the sample.
#
# somalier derives both the output file name and the sample name stored inside
# the .somalier file from the SM tag, which is why the read groups have to be
# rewritten first. The reheadered file is an intermediate only and is removed
# on exit, so the .somalier file is the sole output.
#
# CRAM input is supported and is kept in CRAM, samtools reheader and somalier
# both read it directly, so converting to BAM would only cost an extra copy.
#
# Requires: samtools, somalier
################################################################################

usage() {
  cat <<EOF
Usage: $0 -i input.bam -s sample_name -v variant_sites.vcf.gz -r reference.fa [-t threads] [-h]

  -i   Input file in BAM (or CRAM) format, no index required (required)
  -s   Sample name to set in the SM tag of the @RG definitions (required)
  -v   List of variant sites in compressed VCF format (required)
  -r   Genome reference in FASTA format, with the corresponding index (required)
  -t   Threads (default: number of cores on machine)
  -h   Help
EOF
  exit 1
}

# Defaults
INPUT_BAM=""
SAMPLE_NAME=""
VARIANT_SITES=""
REFERENCE_FASTA=""
NTHREADS="$(nproc)"
TAB=$'\t'  # explicit tab, GNU and BSD sed differ on \t inside [^...]

## Command line arguments
while getopts ":i:s:v:r:t:h" opt; do
  case $opt in
    i) INPUT_BAM="$OPTARG" ;;
    s) SAMPLE_NAME="$OPTARG" ;;
    v) VARIANT_SITES="$OPTARG" ;;
    r) REFERENCE_FASTA="$OPTARG" ;;
    t) NTHREADS="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

# Check required arguments
[[ -n "$INPUT_BAM" ]] || usage
[[ -n "$SAMPLE_NAME" ]] || usage
[[ -n "$VARIANT_SITES" ]] || usage
[[ -n "$REFERENCE_FASTA" ]] || usage

# Tool checks
command -v samtools >/dev/null 2>&1 || { echo "Error: samtools not found in PATH"; exit 1; }
command -v somalier >/dev/null 2>&1 || { echo "Error: somalier not found in PATH"; exit 1; }

# File checks
[[ -f "$INPUT_BAM" ]] || { echo "Error: $INPUT_BAM not found"; exit 1; }
[[ -f "$VARIANT_SITES" ]] || { echo "Error: $VARIANT_SITES not found"; exit 1; }
[[ -f "$REFERENCE_FASTA" ]] || { echo "Error: $REFERENCE_FASTA not found"; exit 1; }
[[ -f "${REFERENCE_FASTA}.fai" ]] || { echo "Error: ${REFERENCE_FASTA}.fai not found"; exit 1; }

# Intermediate files, removed on exit so that only the .somalier file is left behind
TMP_FILES=()
cleanup() { rm -f "${TMP_FILES[@]}"; }
trap cleanup EXIT

# Reheader in the format of the input file
# The input file is read sequentially, so no index is required for either format
if [[ "$INPUT_BAM" == *.cram ]]; then
  RG_FILE="rg.$$.cram"
  RG_INDEX="${RG_FILE}.crai"
else
  RG_FILE="rg.$$.bam"
  RG_INDEX="${RG_FILE}.bai"
fi
TMP_FILES+=("$RG_FILE" "$RG_INDEX")

# Update @RG, rewrite SM
samtools view --no-PG -H -T "$REFERENCE_FASTA" "$INPUT_BAM" \
  | sed -e "/^@RG/ s/SM:[^${TAB}]*/SM:${SAMPLE_NAME}/" \
  | samtools reheader --no-PG - "$INPUT_BAM" > "$RG_FILE" \
  || { echo "Error: samtools reheader failed"; exit 1; }

# Index the reheadered file
samtools index -@ "$NTHREADS" "$RG_FILE" || { echo "Error: samtools index failed"; exit 1; }

# Check file integrity
samtools quickcheck -v "$RG_FILE" || { echo "Error: reheadered ${RG_FILE} is truncated or corrupted"; exit 1; }

# Run somalier extract
somalier extract --sites "$VARIANT_SITES" -f "$REFERENCE_FASTA" "$RG_FILE" \
  || { echo "Error: somalier extract failed"; exit 1; }

echo "Done: ${SAMPLE_NAME}.somalier"
