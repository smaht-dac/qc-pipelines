cwlVersion: v1.0

class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  - id: input_file_bam
    type: File
    secondaryFiles:
      - .bai
    doc: Input file in BAM format with the corresponding index file

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    doc: Genome reference in FASTA format with the corresponding index files

  - id: chromosomes
    type:
      -
        items: string
        type: array
    default: ["chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY", "chrM"]
    doc: List of chromosome names to extract

  - id: nthreads
    type: int
    default: null
    doc: Number of input/output compression threads to use in addition to main thread [0]

outputs:
  output_file_txt:
    type: File
    outputSource: picard_CollectGcBiasMetrics/output_file_txt

  output_summary_txt:
    type: File
    outputSource: picard_CollectGcBiasMetrics/output_summary_txt

  output_chart_pdf:
    type: File
    outputSource: picard_CollectGcBiasMetrics/output_chart_pdf

steps:
  samtools_ExtractChromosomes:
    run: samtools_ExtractChromosomes.cwl
    in:
      input_file_bam:
        source: input_file_bam
      chromosomes:
        source: chromosomes
      nthreads:
        source: nthreads
    out: [output_file_bam]

  picard_CollectGcBiasMetrics:
    run: picard_CollectGcBiasMetrics.cwl
    in:
      input_file_bam:
        source: samtools_ExtractChromosomes/output_file_bam
      genome_reference_fasta:
        source: genome_reference_fasta
    out: [output_file_txt, output_summary_txt, output_chart_pdf]

doc: |
  Run samtools view command to extract specified chromosomes from a BAM file. |
  Run picard CollectGcBiasMetrics command