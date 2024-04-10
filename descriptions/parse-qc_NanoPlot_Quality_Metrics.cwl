#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.nanoplot_metrics_txt)
        entryname: nanoplot.metrics.txt
      - entry: $(inputs.nanoplot_metrics_html)
        entryname: nanoplot.metrics.html

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "NanoPlot Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  # nanoplot ---------------------
  - id: metrics_nanoplot
    type: string
    default: "nanoplot"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: nanoplot_metrics_txt
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  # Additional files to load
  - id: nanoplot_metrics_html
    type: File
    inputBinding:
      prefix: --additional-files
      position: 4

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
    Run parse-qc to generate quality metrics for input FASTQ or unaligned BAM file. |
    Implementation for long reads
