#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/somalier:VERSION

baseCommand: [somalier_extract.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in BAM format. |
         CRAM format is also supported and is kept in CRAM, |
         the genome reference is used to decode it

  - id: sample_name
    type: string
    inputBinding:
      prefix: -s
    doc: Sample name to set in the SM tag of the @RG definitions

  - id: variant_sites
    type: File
    inputBinding:
      prefix: -v
    doc: List of variant sites to extract genotype information for |
         in compressed VCF format

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: -r
    doc: Genome reference in FASTA format with the corresponding index files

outputs:
  - id: output_file_somalier
    type: File
    outputBinding:
      glob: '*.somalier'

doc: |
  Replace the sample name across the @RG definitions of the input BAM file and |
  run Somalier extract function on the reheadered file to |
  extract genotype information for the specified variant sites. |
  Generate a binary output in Somalier-specific format
