#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, MeanQualityByCycle]

arguments: [-Xmx32g, --VALIDATION_STRINGENCY, LENIENT]

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

  - id: output_chart_name
    type: string
    default: "mean_qual_by_cycle.pdf"
    inputBinding:
      prefix: --CHART_OUTPUT
    doc: Name for the output chart in PDF format

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

  - id: output_chart_pdf
    type: File
    outputBinding:
      glob: $(inputs.output_chart_name)

doc: |
  Run picard MeanQualityByCycle command
