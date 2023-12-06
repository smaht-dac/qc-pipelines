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
  - id: input_file_fastq_gz
    type: File
    inputBinding:
      position: 1
    doc: Input file in compressed FASTQ format

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      position: 2
    doc: Specifies the number of files which can be processed simultaneously. |
         Each thread will be allocated 250MB of memory.  |
         You should not run more than 6 threads on a 32 bit machine

outputs:
  - id: output_report_zip
    type: File
    outputBinding:
      glob: "*_fastqc.zip"

  - id: output_summary_txt
    type: File
    outputBinding:
      glob: "summary.txt"

doc: |
  Run FastQC on files in FASTQ format
