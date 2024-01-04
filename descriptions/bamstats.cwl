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

  - id: effective_genome_size
    type: int
    default: 2913022398
    inputBinding:
      prefix: -g
    doc: Effective genome size used to calculate coverage

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "out.txt"

doc: |
  Run bamStats.py script
