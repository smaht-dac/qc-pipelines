#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION

baseCommand: [samtools, flagstat]

inputs:
  - id: input_file_bam
    type: File
    secondaryFiles:
      - .bai
    inputBinding:
      position: 2
    doc: Input file in BAM format with the corresponding index file

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 1
      prefix: --threads
    doc: Set number of additional threads to use when reading the file

outputs:
  - id: output_file_txt
    type: stdout

stdout: output.txt

doc: |
  Run samtools flagstat command
