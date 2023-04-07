#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/fastqc:VERSION

baseCommand: [run.sh]

inputs:
  - id: input_file_fastq
    type: File
    inputBinding:
      position: 1
    doc: Input file in FASTQ format

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      position: 2
    doc: Specifies the number of files which can be processed simultaneously. |
         Each thread will be allocated 250MB of memory.  |
         You should not run more than 6 threads on a 32 bit machine

  - id: output_directory_name
    type: string
    default: "."
    inputBinding:
      position: 3
    doc: Name for the output directory

outputs:
  - id: output_report_zip
    type: File
    outputBinding:
      glob: "*_fastqc.zip"

doc: |
  Run FastQC on files in FASTQ format
