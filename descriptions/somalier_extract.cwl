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
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
    doc: Input file in BAM format with the corresponding index file

  - id: variant_sites
    type: File
    inputBinding:
      position: 2
    doc: List of variant sites to extract genotype information for |
         in compressed VCF format 

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      position: 3
    doc: Genome reference in FASTA format with the corresponding index files

outputs:
  - id: output_file_somalier
    type: File
    outputBinding:
      glob: '*.somalier'

doc: |
  Run Somalier extract function on input BAM file to |
  extract genotype information for the specified variant sites. |
  Generate a binary output in Somalier-specific format
