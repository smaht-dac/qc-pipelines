#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/fastqc:VERSION

baseCommand: [fastqc]

inputs:
  - id: input_file_fastq
    type: File
    inputBinding:
      position: 2
    doc: Input file in FASTQ format

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      position: 1
      prefix: --threads
    doc: Specifies the number of files which can be processed simultaneously. |
         Each thread will be allocated 250MB of memory.  |
         You should not run more than 6 threads on a 32 bit machine

outputs:
  - id: output_report_zip
    type: File
    outputBinding:
      glob: *_fastqc.zip

doc: |
  Run FastQC on files in FASTQ format
