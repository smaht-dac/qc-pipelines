#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, CollectWgsMetrics]

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

  - id: minimum_base_quality
    type: int
    default: null
    inputBinding:
      prefix: -Q
    doc: Minimum base quality for a base to contribute coverage [20]

  - id: minimum_mapping_quality
    type: int
    default: null
    inputBinding:
      prefix: -MQ
    doc: Minimum mapping quality for a read to contribute coverage [20]

  - id: read_length
    type: int
    default: null
    inputBinding:
      prefix: --READ_LENGTH
    doc: Average read length in the file [150]

  - id: count_unpaired
    default: null
    inputBinding:
      prefix: --COUNT_UNPAIRED
    type: boolean
    doc: If true, count unpaired reads, and paired reads with one end unmapped [false]

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

doc: |
  Run picard CollectWgsMetrics command
