#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/bamstats:VERSION

baseCommand: [run.sh]

inputs:
  - id: input_bam
    type: File
    inputBinding:
      position: 1
    doc: Input file in BAM format

  - id: genome_size
    type: int
    inputBinding:
      position: 2
    doc: Genome size used to calculate coverage

outputs:
  - id: out
    type: File
    outputBinding:
      glob: "out.txt"


doc: |
  Run bamStats script
