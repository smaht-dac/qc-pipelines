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
  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: --fasta
      position: 1
    doc: Genome reference in FASTA format with the corresponding index files

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 2
      prefix: -t
    doc: Number of threads to use [1]

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      position: 3

  - id: input_file_cram
    type: File
    secondaryFiles:
      - .crai
    inputBinding:
      position: 4
    doc: Input file in CRAM format with the corresponding index file

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
  Run mosdepth on input file in CRAM format
