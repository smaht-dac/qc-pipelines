#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_rnaseqc_json)
        entryname: rnaseqc.summary.json
      - entry: $(inputs.input_rnaseqc_tar_gz)
        entryname: rnaseqc.out.tar.gz
      - entry: $(inputs.input_classifier_txt)
        entryname: classifier.out.txt

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
  # rnaseqc
  - id: metrics_rnaseqc
    type: string
    default: "rnaseqc"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: input_rnaseqc_json
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  # tissue_classifier
  - id: metrics_tissue_classifier
    type: string
    default: "tissue_classifier"
    inputBinding:
      prefix: --metrics
      position: 4

  - id: input_classifier_txt
    type: File
    inputBinding:
      position: 5
  # ------------------------------

  # Additional files to load
  - id: input_rnaseqc_tar_gz
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
    Run parse-qc to generate quality metrics for input BAM file. |
    Implementation for RNA-seq. |
    Generate metrics for RNA-SeQC and Tissue Classifier
