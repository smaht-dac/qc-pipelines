#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: ACCOUNT/mosdepth:VERSION

baseCommand: [mosdepth_index.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in BAM format

  - id: nthreads
    type: int
    default: 4
    inputBinding:
      prefix: -t
    doc: Number of threads to use [4]

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      prefix: -o

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
