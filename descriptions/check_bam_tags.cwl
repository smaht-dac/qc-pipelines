#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION

baseCommand: [check_bam_tags.py]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in BAM format

  - id: required_tags
    type:
      -
        items: string
        type: array
    inputBinding:
      prefix: -l
    doc: List of tags to validate

  - id: nthreads
    type: int
    default: null
    inputBinding:
      prefix: -t
    doc: Number of input/output compression threads to use in addition to main thread [1]

outputs:
  - id: output_log_txt
    type: File
    outputBinding:
      glob: log.txt

doc: |
  Run check_bam_tags.py to validate tags in a BAM file
