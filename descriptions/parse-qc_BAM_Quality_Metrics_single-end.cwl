#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.SAMTOOLS_stats_OUTPUT)
        entryname: samtools.stats.txt
      - entry: $(inputs.SAMTOOLS_flagstat_OUTPUT)
        entryname: samtools.flagstat.txt
      - entry: $(inputs.SAMTOOLS_idxstats_OUTPUT)
        entryname: samtools.idxstats.txt
      - entry: $(inputs.PICARD_CollectAlignmentSummaryMetrics_OUTPUT)
        entryname: picard.CollectAlignmentSummaryMetrics.txt
      - entry: $(inputs.PICARD_CollectBaseDistributionByCycle_OUTPUT)
        entryname: picard.CollectBaseDistributionByCycle.txt
      - entry: $(inputs.PICARD_CollectBaseDistributionByCycle_PDF)
        entryname: picard.CollectBaseDistributionByCycle.pdf
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_OUTPUT)
        entryname: picard.CollectGcBiasMetrics.txt
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_SUMMARY)
        entryname: picard.CollectGcBiasMetrics.summary.txt
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_PDF)
        entryname: picard.CollectGcBiasMetrics.pdf
      - entry: $(inputs.PICARD_MeanQualityByCycle_OUTPUT)
        entryname: picard.MeanQualityByCycle.txt
      - entry: $(inputs.PICARD_MeanQualityByCycle_PDF)
        entryname: picard.MeanQualityByCycle.pdf
      - entry: $(inputs.BAMSTATS_OUTPUT)
        entryname: bamstats.output.txt

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "BAM Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  #  samtools_stats
  - id: metrics_samtools_stats
    type: string
    default: "samtools_stats"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: SAMTOOLS_stats_OUTPUT
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  #  picard_CollectAlignmentSummaryMetrics
  - id: metrics_picard_CollectAlignmentSummaryMetrics
    type: string
    default: "picard_CollectAlignmentSummaryMetrics"
    inputBinding:
      prefix: --metrics
      position: 4

  - id: PICARD_CollectAlignmentSummaryMetrics_OUTPUT
    type: File
    inputBinding:
      position: 5
  # ------------------------------

  #  bamstats
  - id: metrics_bamstats
    type: string
    default: "bamstats"
    inputBinding:
      prefix: --metrics
      position: 6

  - id: BAMSTATS_OUTPUT
    type: File
    inputBinding:
      position: 7
  # ------------------------------

  - id: SAMTOOLS_flagstat_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 8

  - id: SAMTOOLS_idxstats_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 9

  - id: PICARD_CollectBaseDistributionByCycle_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 10

  - id: PICARD_CollectBaseDistributionByCycle_PDF
    type: File
    inputBinding:
      prefix: --additional-files
      position: 11

  - id: PICARD_CollectGcBiasMetrics_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 12

  - id: PICARD_CollectGcBiasMetrics_SUMMARY
    type: File
    inputBinding:
      prefix: --additional-files
      position: 13

  - id: PICARD_CollectGcBiasMetrics_PDF
    type: File
    inputBinding:
      prefix: --additional-files
      position: 14

  - id: PICARD_MeanQualityByCycle_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 15

  - id: PICARD_MeanQualityByCycle_PDF
    type: File
    inputBinding:
      prefix: --additional-files
      position: 16

outputs:
  - id: qc_values_json
    type: File
    outputBinding:
      glob: "qc_values.json"

  - id: metrics_zip
    type: File
    outputBinding:
      glob: "metrics.zip"

doc: |
    Run parse-qc to generate quality metrics for input BAM file. |
    Implementation for single-end reads
