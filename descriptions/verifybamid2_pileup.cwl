#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/verifybamid2:VERSION

baseCommand: [verifybamid2]

inputs:
  - id: input_pileup_tsv
    type: File
    inputBinding:
      prefix: --PileupFile
    doc: Input pileup file in TSV format

  - id: genome_reference_fasta
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    inputBinding:
      prefix: --Reference
    doc: Genome reference in FASTA format with the corresponding index files

  - id: resources_vb2
    type: File
    secondaryFiles:
      - ^.mu
      - ^.UD
      - ^.bed
    inputBinding:
      prefix: --SVDPrefix
      valueFrom: $(self.path.match(/(.*)\.[^.]+$/)[1])
    doc: Prefix to resource files

  - id: nthreads
    type: int
    default: null
    inputBinding:
      prefix: --NumThread
    doc: Set number of threads in likelihood calculation [4]

outputs:
  - id: output_file_txt
    type: stdout

stdout: output.txt

doc: |
  Run VerifyBamID2 to check the input TSV pileup file for contamination
