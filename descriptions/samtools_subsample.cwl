#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION

baseCommand: [samtools_subsample.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in BAM format

  - id: subsample_fraction
    type: float
    default: null
    inputBinding:
      prefix: -r
    doc: Output only a proportion of the input alignments, |
         as specified by 0.0 ≤ FLOAT ≤ 1.0,|
         which gives the fraction of templates/pairs to be kept. |
         This subsampling acts in the same way on all of the alignment records |
         in the same template or read pair, |
         so it never keeps a read but not its mate

  - id: subsample_seed
    type: int
    default: null
    inputBinding:
      prefix: -s
    doc: Subsampling seed used to influence which subset of reads is kept. |
         When subsampling data that has previously been subsampled, |
         be sure to use a different seed value from those used previously; |
         otherwise more reads will be retained than expected [0]

  - id: nthreads
    type: int
    default: null
    inputBinding:
      prefix: -t
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      prefix: -o

  - id: effective_genome_size
    type: long
    default: null
    inputBinding:
      prefix: -g
    doc: Effective genome size. |
         As a default it is used GRCh38/hg38 [2913022398]

  - id: input_file_stats
    type: File
    default: null
    inputBinding:
      prefix: -l
    doc: Output from samtools stats. |
         This file is used to calculate the correct ratio |
         to subsample the input BAM file at specified coverage level

  - id: coverage
    type: int
    default: null
    inputBinding:
      prefix: -c
    doc: Desired coverage

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + ".bam")
    secondaryFiles:
      - .bai

doc: |
  Run samtools view wrapper to subsample a BAM file. |
  Generate the corresponding index file
