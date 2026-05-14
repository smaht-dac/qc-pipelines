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
  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: --reference
      position: 1
    doc: Genome reference in FASTA format with the corresponding index files

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 2
      prefix: --threads
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: input_file_cram
    type: File
    inputBinding:
      position: 3
    doc: Input file in CRAM format

outputs:
  - id: output_file_txt
    type: stdout

stdout: output.txt

doc: |
  Run samtools stats command on input file in CRAM format
