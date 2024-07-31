#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/kraken2:VERSION

baseCommand: [run.sh]

inputs:
  - id: input_file_fastq_gz
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in compressed FASTQ format

  - id: database
    type: File
    inputBinding:
      prefix: -d
    doc: Compressed archive for Kraken2 database files

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      prefix: -t
    doc: Number of threads to use for k-mer classification

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "kraken2_report.txt"

doc: |
  Run Kraken2
