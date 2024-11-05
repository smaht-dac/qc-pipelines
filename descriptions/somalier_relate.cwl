#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/somalier:VERSION

baseCommand: [somalier_relate.sh]

inputs:
  - id: input_files_somalier
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 3
    doc: Expect a list of .somalier files |
         generated from corresponding BAM files |
         using Somalier extract function

  - id: threshold
    type: float
    default: 0.8
    inputBinding:
      position: 1
    doc: Threshold for relatedness |
         must be in range from 0 to 1

  - id: output_prefix
    type: string
    default: "out"
    inputBinding:
      position: 2
    doc: Prefix for the output

outputs:
  - id: output_file_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).pairs.tsv

doc: |
  Run Somalier relate function on a specified set of .somalier files
