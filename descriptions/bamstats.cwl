#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/bamstats:VERSION

baseCommand: [bamStats.py]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -b
    doc: Input file in BAM format

  - id: effective_genome_size
    type: long
    default: null
    inputBinding:
      prefix: -g
    doc: Effective genome size. |
         As a default it is used GRCh38/hg38 [2913022398]

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "out.txt"

doc: |
  Run bamStats.py script
