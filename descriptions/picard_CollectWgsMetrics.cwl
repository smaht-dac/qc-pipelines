#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [picard, CollectWgsMetrics]

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
    type: boolean
    default: null
    inputBinding:
      prefix: --COUNT_UNPAIRED
    doc: If true, count unpaired reads, and paired reads with one end unmapped [false]

  - id: interval_list
    type: File
    default: null
    inputBinding:
      prefix: --INTERVALS
    doc: An interval list file that contains the positions to restrict the assessment |
         in Picard interval_list format

  - id: coverage_cap
    type: int
    default: 1000
    inputBinding:
      prefix: --COVERAGE_CAP
    doc: Treat positions with coverage exceeding this value |
         as if they had coverage at this value [1000]

outputs:
  - id: output_file_txt
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

doc: |
  Run picard CollectWgsMetrics command
