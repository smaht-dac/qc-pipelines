#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/bamstats:VERSION

baseCommand: [python, bamStats.py]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -b
    doc: Input file in BAM format

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "out.txt"

doc: |
  Run bamStats.py script
