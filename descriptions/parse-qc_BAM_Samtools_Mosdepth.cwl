#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.SAMTOOLS_stats_OUTPUT)
        entryname: samtools.stats.txt
      - entry: $(inputs.MOSDEPTH_SUMMARY)
        entryname: mosdepth.summary.txt
      - entry: $(inputs.MOSDEPTH_OUTPUT)
        entryname: mosdepth.output.txt

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/parseqc:VERSION

baseCommand: [parse-qc]

inputs:
  # Input arguments
  - id: qm_name
    type: string
    default: "BAM Quality Metrics"
    inputBinding:
      prefix: --qm-name
      position: 1
    doc: Name of the Quality Metric

  # Files to parse per metric type
  #  samtools_stats
  - id: metrics_samtools_stats
    type: string
    default: "samtools_stats"
    inputBinding:
      prefix: --metrics
      position: 2

  - id: SAMTOOLS_stats_OUTPUT
    type: File
    inputBinding:
      position: 3
  # ------------------------------

  #  mosdepth
  - id: metrics_mosdepth
    type: string
    default: "mosdepth"
    inputBinding:
      prefix: --metrics
      position: 4

  - id: MOSDEPTH_SUMMARY
    type: File
    inputBinding:
      position: 5
  # ------------------------------

  - id: MOSDEPTH_OUTPUT
    type: File
    inputBinding:
      prefix: --additional-files
      position: 6

outputs:
  - id: qc_values_json
    type: File
    outputBinding:
      glob: "qc_values.json"

  - id: metrics_zip
    type: File
    outputBinding:
      glob: "metrics.zip"

doc: |
    Run parse-qc to generate quality metrics for samtools stats and mosdepth outputs
