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
      - entry: $(inputs.kraken2_report_txt)
        entryname: kraken2.report.txt

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "FASTQ Quality Metrics"
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

  # kraken2
  - id: metrics_kraken2
    type: string
    default: "kraken2"
    inputBinding:
      prefix: --metrics
      position: 4

  - id: kraken2_report_txt
    type: File
    inputBinding:
      position: 5
  # ------------------------------

  # Additional files to load
  - id: fastqc_report_zip
    type: File
    inputBinding:
      prefix: --additional-files
      position: 6

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
    Run parse-qc to generate quality metrics for input FASTQ file. |
    Iplementation for short reads using FastQC
