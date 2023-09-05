#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, CollectGcBiasMetrics]

arguments: [-Xmx32g]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -I
    doc: Input file in BAM format

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: -R
    doc: Genome reference in FASTA format with the corresponding index files

  - id: output_file_name
    type: string
    default: "output.txt"
    inputBinding:
      prefix: -O
    doc: Name for the output file in TXT format

  - id: output_summary_name
    type: string
    default: "summary.txt"
    inputBinding:
      prefix: -S
    doc: Name for the output summary in TXT format

  - id: output_chart_name
    type: string
    default: "gc_bias_metrics.pdf"
    inputBinding:
      prefix: --CHART_OUTPUT
    doc: Name for the output chart in PDF format

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

  - id: output_summary_txt
    type: File
    outputBinding:
      glob: $(inputs.output_summary_name)

  - id: output_chart_pdf
    type: File
    outputBinding:
      glob: $(inputs.output_chart_name)

doc: |
  Run picard CollectGcBiasMetrics command
