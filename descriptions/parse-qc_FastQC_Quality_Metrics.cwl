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
    default: 'FastQC Quality Metrics'
    inputBinding:
      prefix: --qm-name
    doc: Name of the Quality Metric

  # Files to load
  - id: fastqc_summary_txt
    type: File
    inputBinding:
      prefix: "--metrics fastqc"

  - id: fastqc_report_zip
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
    Run parse-qc to generate quality metrics for input FASTQ file
