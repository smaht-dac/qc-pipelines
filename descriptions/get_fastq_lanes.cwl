#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/fastqc:VERSION

baseCommand: [get_fastq_lanes.py]

inputs:
  - id: input_file_fastq_gz
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in FASTQ format. |
         Expect a compressed file

  - id: output_file_name
    type: string
    default: "output.txt"
    inputBinding:
      prefix: -o
    doc: Name for the output file in TXT format

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

doc: |
  Run get_fastq_lanes.py to collect |
  lane identifiers in input FASTQ file
