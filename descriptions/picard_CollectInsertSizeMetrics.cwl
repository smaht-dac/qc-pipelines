#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, CollectInsertSizeMetrics]

arguments: [-Xmx32g]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -I
    doc: Input file in BAM format

  - id: output_file_name
    type: string
    default: "output.txt"
    inputBinding:
      prefix: -O
    doc: Name for the output file in TXT format

  - id: output_histogram_name
    type: string
    default: "insert_size_histogram.pdf"
    inputBinding:
      prefix: -H
    doc: Name for the output histogram in PDF format

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

  - id: output_histogram_pdf
    type: File
    outputBinding:
      glob: $(inputs.output_histogram_name)

doc: |
  Run picard CollectInsertSizeMetrics command
