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

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: 'BAM Quality Metrics'
    inputBinding:
      prefix: --qm-name
    doc: Name of the Quality Metric

  # Files to load
  - id: SAMTOOLS_stats_OUTPUT
    type: File
    inputBinding:
      prefix: "--metrics samtools_stats"

  - id: PICARD_CollectAlignmentSummaryMetrics_OUTPUT
    type: File
    inputBinding:
      prefix: "--metrics picard_CollectAlignmentSummaryMetrics"

  - id: PICARD_CollectInsertSizeMetrics_OUTPUT
    type: File
    inputBinding:
      prefix: "--metrics picard_CollectInsertSizeMetrics"

  - id: PICARD_CollectWgsMetrics_OUTPUT
    type: File
    inputBinding:
      prefix: "--metrics picard_CollectWgsMetrics"

  - id: SAMTOOLS_flagstat_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files

  - id: SAMTOOLS_idxstats_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectBaseDistributionByCycle_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectBaseDistributionByCycle_PDF
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectGcBiasMetrics_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectGcBiasMetrics_SUMMARY
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectGcBiasMetrics_PDF
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_CollectInsertSizeMetrics_PDF
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_MeanQualityByCycle_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files

  - id: PICARD_MeanQualityByCycle_PDF
    type: File
    inputBinding:
      prefix: --additional-files

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
    Run parse-qc to generate quality metrics for input BAM file
