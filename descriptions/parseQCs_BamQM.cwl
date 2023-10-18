#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.SAMTOOLS_stats_OUTPUT)
        entryname: output.samtools.stats
      - entry: $(inputs.SAMTOOLS_flagstat_OUTPUT)
        entryname: output.samtools.flagstat
      - entry: $(inputs.SAMTOOLS_idxstats_OUTPUT)
        entryname: output.samtools.idxstats
      - entry: $(inputs.PICARD_CollectAlignmentSummaryMetrics_OUTPUT)
        entryname: output.picard.CollectAlignmentSummaryMetrics
      - entry: $(inputs.PICARD_CollectBaseDistributionByCycle_OUTPUT)
        entryname: output.picard.CollectBaseDistributionByCycle
      - entry: $(inputs.PICARD_CollectBaseDistributionByCycle_PDF)
        entryname: collect_base_dist_by_cycle.pdf
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_OUTPUT)
        entryname: output.picard.CollectGcBiasMetrics
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_SUMMARY)
        entryname: summary.picard.CollectGcBiasMetrics
      - entry: $(inputs.PICARD_CollectGcBiasMetrics_PDF)
        entryname: gc_bias_metrics.pdf
      - entry: $(inputs.PICARD_CollectInsertSizeMetrics_OUTPUT)
        entryname: output.picard.CollectInsertSizeMetrics
      - entry: $(inputs.PICARD_CollectInsertSizeMetrics_PDF)
        entryname: insert_size_histogram.pdf
      - entry: $(inputs.PICARD_CollectWgsMetrics_OUTPUT)
        entryname: output.picard.CollectWgsMetrics
      - entry: $(inputs.PICARD_MeanQualityByCycle_OUTPUT)
        entryname: output.picard.MeanQualityByCycle
      - entry: $(inputs.PICARD_MeanQualityByCycle_PDF)
        entryname: mean_qual_by_cycle.pdf

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: ["parse-qc"]

inputs:
  # Input arguments
  - id: qmtype
    type: string
    default: 'BAM Quality Metrics'
    inputBinding:
      prefix: --qm-name
    doc: Name of the Quality Metric

  # Files to load
  - id: SAMTOOLS_stats_OUTPUT
    inputBinding:
      prefix: "--metrics samtools"
    type: File

  - id: PICARD_CollectAlignmentSummaryMetrics_OUTPUT
    inputBinding:
      prefix: "--metrics picard_CollectAlignmentSummaryMetrics"
    type: File

  - id: PICARD_CollectInsertSizeMetrics_OUTPUT
    inputBinding:
      prefix: "--metrics picard_CollectInsertSizeMetrics"
    type: File

  - id: PICARD_CollectWgsMetrics_OUTPUT
    inputBinding:
      prefix: "--metrics picard_CollectWgsMetrics"
    type: File

  - id: SAMTOOLS_flagstat_OUTPUT
    inputBinding:
      prefix: --additional-files
    type: File

  - id: SAMTOOLS_idxstats_OUTPUT
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectBaseDistributionByCycle_OUTPUT
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectBaseDistributionByCycle_PDF
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectGcBiasMetrics_OUTPUT
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectGcBiasMetrics_SUMMARY
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectGcBiasMetrics_PDF
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_CollectInsertSizeMetrics_PDF
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_MeanQualityByCycle_OUTPUT
    inputBinding:
      prefix: --additional-files
    type: File

  - id: PICARD_MeanQualityByCycle_PDF
    inputBinding:
      prefix: --additional-files
    type: File

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
    Run parse-qc to generate BamQM quality metrics
