#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/fastqc:VERSION

baseCommand: [compare_lanes.py]

inputs:
  - id: input_files_txt
    type:
      -
        items: File
        type: array
    inputBinding:
      prefix: -i
    doc: Expect a list of TXT files generated |
         from corresponding FASTQ files |
         with lane identifiers listed as a column |
         and header storing the original FASTQ file name

         #   E.g.,
         #       #- SMAUR5IPLE5A.fastq.gz
         #       LH00180_99_2235GWLT4_8
         #       LH00180_99_2235GWLT4_6

outputs:
  - id: output_log_txt
    type: stdout

stdout: log.txt

doc: |
  Run compare_lanes.py to compare lane identifiers |
  across multiple FASTQ files checking for duplicates
