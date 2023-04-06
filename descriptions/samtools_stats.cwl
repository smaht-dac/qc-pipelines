#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION

baseCommand: [samtools, stats]

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
    doc: Number of input/output compression threads to use in addition to main thread [0]

outputs:
  - id: output_file_txt
    type: stdout

stdout: output.txt

doc: |
  Run samtools stats command
