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
      position: 2
    doc: Expect a list of .somalier files |
         generated from corresponding BAM files |
         using Somalier extract function

  - id: output_prefix
    type: string
    default: "out"
    inputBinding:
      position: 1
    doc: Prefix for the output

outputs:
  - id: output_pairs_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).pairs.tsv

doc: |
  Run Somalier relate function on a specified set of .somalier files
