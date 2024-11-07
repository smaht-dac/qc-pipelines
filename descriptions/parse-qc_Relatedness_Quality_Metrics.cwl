#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_pairs_tsv)
        entryname: somalier.pairs.tsv

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "Relatedness Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  # somalier
  - id: metrics_somalier
    type: string
    default: "somalier"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: input_pairs_tsv
    type: File
    inputBinding:
      position: 3
  # ------------------------------

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
    Implementation for Somalier
