#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, CollectAlignmentSummaryMetrics]

arguments: [-Xmx32g, --VALIDATION_STRINGENCY, LENIENT]

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

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

doc: |
  Run picard CollectAlignmentSummaryMetrics command. |
  Implementation for standard paired-end sequencing with read pairs in FR orientation
