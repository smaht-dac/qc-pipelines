#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/tissue_classifier:VERSION

baseCommand: [tissue_classifier_predict.py]

inputs:
  - id: classifier
    type: File
    inputBinding:
      prefix: -c
    doc: Compressed, trained random forest model

  - id: rnaseqc_output
    type: File
    inputBinding:
      prefix: -r
    doc: Gene TPM output of RNA-SeQC

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "output.txt"

doc: |
  Run tissue classifier on a RNA-SeQC output
