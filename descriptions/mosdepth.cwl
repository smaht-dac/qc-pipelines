#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/mosdepth:VERSION

baseCommand: [mosdepth, -n, --fast-mode]

inputs:
  - id: input_file_bam
    type: File
    secondaryFiles:
      - .bai
    inputBinding:
      position: 3
    doc: Input file in BAM format with the corresponding index file

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 1
      prefix: -t
    doc: Number of threads to use [1]

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      position: 2

outputs:
  - id: output_summary_txt
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + ".mosdepth.summary.txt")

  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + ".mosdepth.global.dist.txt")

doc: |
  Run mosdepth
