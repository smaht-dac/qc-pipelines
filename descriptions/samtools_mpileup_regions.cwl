#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION

baseCommand: [samtools_mpileup_regions.sh]

inputs:
  - id: input_file_bam
    type: File
    secondaryFiles:
      - .bai
    inputBinding:
      prefix: -b
    doc: Input file in BAM format with the corresponding index file

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: -r
    doc: Genome reference in FASTA format with the corresponding index files

  - id: regions
    type: File
    inputBinding:
      prefix: -l
    doc: Regions to be processed in TXT format.|
         One region per line in the format "chr:start-end"

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      prefix: -o

  - id: samtools_flags
    type: string
    default: null
    inputBinding:
      prefix: -f
    doc: Flags to be passed to samtools mpileup as string. |
         Default from the software is "-B -a -s -q 1" 

outputs:
  - id: output_pileup_tsv
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + ".tsv")

doc: |
  Run samtools mpileup for input file in BAM format on a set of specified regions. |
  Each region is processed in parallel and the output merged into a single file
