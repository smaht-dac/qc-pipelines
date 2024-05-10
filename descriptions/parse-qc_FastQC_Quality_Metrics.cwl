#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.fastqc_summary_txt)
        entryname: fastqc.summary.txt
      - entry: $(inputs.fastqc_report_zip)
        entryname: fastqc.report.zip

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "FastQC Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  # fastqc
  - id: metrics_fastqc
    type: string
    default: "fastqc"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: fastqc_summary_txt
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  # Additional files to load
  - id: fastqc_report_zip
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
    Run parse-qc to generate quality metrics for input FASTQ file
