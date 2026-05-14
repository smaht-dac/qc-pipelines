#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/mosdepth:VERSION

baseCommand: [mosdepth_index.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      position: 1
    doc: Input file in BAM format

  - id: nthreads
    type: int
    default: 4
    inputBinding:
      position: 2
    doc: Number of threads to use [4]

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      position: 3

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
  Index the input BAM file and run mosdepth
