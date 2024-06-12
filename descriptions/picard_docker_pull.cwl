#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/picard:VERSION

baseCommand: [echo, "pulled picard docker image!"]

inputs: []

outputs:
  - id: output_log_txt
    type: stdout

stdout: log.txt

doc: |
    Empty CWL to be used for pre-pulling the picard Docker image