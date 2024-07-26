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
  - id: input_file_fastq_r1
    type: File
    inputBinding:
      position: 1
    doc: Input file. |
         Compressed FASTQ file (Single-end or paired-end R1)
    
  - id: input_file_fastq_r2
    type: File
    default: null
    inputBinding:
      position: 2
    doc: Input file. |
         Compressed FASTQ file (R2)

  - id: database
    type: File
    inputBinding:
      position: 3
    doc: Compressed Kraken2 database file (tar.gz)

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      position: 4
    doc: Number of threads to use for k-mer classification

outputs:
  
  - id: output_file_txt
    type: File
    outputBinding:
      glob: "kraken2_report.txt"

doc: |
  Run Kraken2
