#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.SAMTOOLS_stats_OUTPUT)
        entryname: samtools.stats.txt
      - entry: $(inputs.PIGEON_filter_REPORT)
        entryname: pigeon.filter.report.json
      - entry: $(inputs.PIGEON_filter_SUMMARY)
        entryname: pigeon.filter.summary.txt
      - entry: $(inputs.PIGEON_classify_REPORT)
        entryname: pigeon.classify.report.json
      - entry: $(inputs.PIGEON_classify_SUMMARY)
        entryname: pigeon.classify.summary.txt
      - entry: $(inputs.ISOSEQ_collapse_REPORT)
        entryname: isoseq.collapse.report.json
      - entry: $(inputs.PIGEON_report_SATURATION)
        entryname: pigeon.report.saturation.txt

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "Kinnex Quality Metrics"
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

  #  pigeon_filter_json
  - id: metrics_pigeon_filter_json
    type: string
    default: "pigeon_filter_json"
    inputBinding:
      prefix: --metrics
      position: 4

  - id: PIGEON_filter_REPORT
    type: File
    inputBinding:
      position: 5
  # ------------------------------

  - id: PIGEON_filter_SUMMARY
    type: File
    inputBinding:
      prefix: --additional-files
      position: 6

  - id: PIGEON_classify_REPORT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 7

  - id: PIGEON_classify_SUMMARY
    type: File
    inputBinding:
      prefix: --additional-files
      position: 8

  - id: ISOSEQ_collapse_REPORT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 9

  - id: PIGEON_report_SATURATION
    type: File
    inputBinding:
      prefix: --additional-files
      position: 10

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
    Implementation for Kinnex RNA-seq
