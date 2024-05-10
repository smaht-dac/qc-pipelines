#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_file_json)
        entryname: rnaseqc.summary.json
      - entry: $(inputs.input_tar_gz)
        entryname: rnaseqc.out.tar.gz

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "RNA-SeQC Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  # fastqc -----------------------
  - id: metrics_rnaseqc
    type: string
    default: "rnaseqc"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: input_file_json
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  # Additional files to load
  - id: input_tar_gz
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
    Run parse-qc to generate quality metrics for input BAM file. |
    Implementation for RNA-seq
