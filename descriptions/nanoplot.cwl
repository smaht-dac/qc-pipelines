#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/nanoplot:VERSION

baseCommand: [run.sh]

inputs:
  - id: input_file
    type: File
    inputBinding:
      position: 1
    doc: Input file. |
         Could be FASTQ or unmapped BAM (uBAM)

outputs:
  - id: output_file_html
    type: File
    outputBinding:
      glob: "NanoPlot-report.html"

  - id: output_file_txt
    type: File
    outputBinding:
      glob: "NanoStats.txt"

doc: |
  Run NanoPlot
