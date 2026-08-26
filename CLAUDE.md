# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**qc-pipelines** is a collection of quality control (QC) pipeline components for genomic data analysis. It is part of the SMaHT Data Analysis Center (smaht-dac) initiative and provides standardized workflows for analyzing sequencing data across multiple modalities (short reads, long reads, RNA-seq).

**Repository**: https://github.com/smaht-dac/qc-pipelines  
**Key Maintainers**: Michele Berselli, Dominika Maziec

## Architecture

The repository is organized into four main components:

### 1. **Descriptions** (`descriptions/` - 36 CWL files)
Individual Command Line Tool (CWL v1.0) definitions for specific QC operations. These are atomic, reusable tools that wrap external bioinformatics software and custom scripts. Each tool:
- Runs a single command or Python script
- Defines inputs (files, parameters), outputs, and Docker requirements
- Uses placeholder `ACCOUNT/TOOL:VERSION` Docker image tags (replaced at deployment)

**Key tool categories**:
- **Alignment QC**: samtools (stats, flagstat, idxstats, subsample), Picard tools (CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, CollectWgsMetrics, etc.)
- **Sequence QC**: FastQC, NanoPlot, Kraken2
- **Coverage**: mosdepth
- **Contamination/Identity**: VerifyBamID2, Somalier (extract, relate)
- **RNA-seq**: RNA-SeQC metrics collection, tissue classifier prediction
- **Parsing**: parse-qc tools that aggregate metrics from multiple tools into standardized JSON format

### 2. **Portal Objects** (`portal_objects/`)
Metadata and orchestration configuration for the SMaHT portal system:

#### **Workflows** (`workflows/` - 33 YAML files)
High-level descriptions of individual CWL tools. Each workflow YAML defines:
- Tool metadata (name, description, category)
- Input/output specifications with semantic types (file.bam, file.fa, parameter.integer, etc.)
- Software versions
- Runner configuration (points to the corresponding .cwl file in `descriptions/`)

#### **Meta-Workflows** (`metaworkflows/` - 7 YAML files)
Complex pipelines that orchestrate multiple workflows into complete analysis pipelines:
- **FASTQ QC**: `Illumina_FASTQ_quality_metrics.yaml`, `short_reads_FASTQ_quality_metrics.yaml`, `long_reads_FASTQ_quality_metrics.yaml`
- **BAM QC**: `paired-end_short_reads_BAM_quality_metrics_GRCh38.yaml`, `long_reads_BAM_quality_metrics_GRCh38.yaml`, `ultra-long_reads_BAM_quality_metrics_GRCh38.yaml`
- **Sample Identity**: `sample_identity_check.yaml`

Each meta-workflow:
- Specifies required reference files and resources (genome FASTA, interval lists, Kraken2 DB, VerifyBamID2 resources)
- Defines QC rulesets with threshold-based pass/fail criteria
- Uses `scatter` to parallelize operations across multiple input files
- Configures EC2 instance types for execution

#### **Reference Files** (`file_reference.yaml`)
Metadata for external reference files (VerifyBamID2 resources, Kraken2 databases, Somalier variant sites, tissue classifier models) with accessions, UUIDs, and versions.

#### **Software** (`software.yaml`)
Registry of software versions and source URLs used across all tools.

### 3. **Dockerfiles** (`dockerfiles/` - 13 images)
Container definitions for each tool. Structure pattern:
```
dockerfiles/TOOL_NAME/
├── Dockerfile          # Ubuntu 22.04 base, Python 3.8, conda
├── SCRIPT.py           # Tool-specific Python helper scripts
└── [supporting files]  # Configs, interval lists, etc.
```

**Maintained images**:
- `samtools`, `picard`, `gatk4`, `fastqc`, `mosdepth`, `somalier`, `rnaseqc`
- `kraken2`, `nanoplot`, `bamstats`, `verifybamid2`, `tissue_classifier`, `parseqc`

Base image: `public.ecr.aws/smaht-dac/base-ubuntu2204-py38:0.0.1` (Ubuntu 22.04 with Python 3.8)

**Note**: All Dockerfiles use placeholder image tags (`ACCOUNT/TOOL:VERSION`) that are substituted at deployment time.

### 4. **Supporting Files**
- `LICENSE`: Apache 2.0
- `PIPELINE`: Single-line identifier file ("qc-pipelines")
- `.gitignore`: Standard Python/build artifacts

## Core Technologies

- **Workflow Language**: Common Workflow Language (CWL v1.0)
- **Container**: Docker
- **Bioinformatics Tools**: Picard, Samtools, FastQC, Kraken2, mosdepth, Somalier, RNA-SeQC, VerifyBamID2, NanoPlot
- **Custom Tools**: qc-parser (v0.8.3) for metric aggregation, Python-based utilities (tissue classifier, etc.)
- **Deployment**: SMaHT portal system with EC2 orchestration

## Development Workflows

### Building Docker Images

Each tool has a Dockerfile in `dockerfiles/TOOL_NAME/`. To build:
```bash
cd dockerfiles/TOOL_NAME
docker build -t ACCOUNT/TOOL:VERSION .
```

Note: The `ACCOUNT` and `VERSION` placeholders in the Dockerfiles are substituted during deployment. For local testing, replace these with your registry and version.

### Creating or Modifying CWL Tools

1. Define the tool in `descriptions/TOOL_NAME.cwl` using CWL v1.0 syntax
2. Create the workflow metadata in `portal_objects/workflows/TOOL_NAME.yaml`
3. Add the Docker image reference to the tool's hints section
4. If the tool is part of a new QC category, add it to the appropriate meta-workflow in `portal_objects/metaworkflows/`

CWL tools typically:
- Use `InitialWorkDirRequirement` to stage inputs and rename files for parsing
- Define `baseCommand` and `inputBinding` for shell command construction
- Specify stdout/stderr redirects for file outputs
- Include `DockerRequirement` for containerization

### Adding Tools to Meta-Workflows

1. Define workflow steps in the YAML with `input`, `output`, and `scatter` directives
2. Specify resource file bindings (e.g., `files: [reference@version]`)
3. Define QC thresholds as `qc_ruleset` objects with rule expressions
4. Configure EC2 instance types and EBS size scaling factors

### Script Development

Custom scripts are located in `dockerfiles/TOOL_NAME/`. Common patterns:

- **Metric Aggregation** (e.g., `collect_rnaseqc_metrics.py`): Parse tool outputs, calculate derived metrics, output JSON
- **Tissue Classification** (e.g., `tissue_classifier_predict.py`): Load pickled models, featurize inputs, predict
- **BAM/FASTQ Processing** (e.g., `check_bam_tags.py`): Validate file formats, extract metadata
- **Shell wrappers** (e.g., `somalier_extract.sh`, `fastqc/run.sh`): Wrap tool invocations that need bash logic before/after execution

Python scripts use Click for CLI argument handling and often include CSV/TSV/JSON parsing.

## File Organization Reference

```
qc-pipelines/
├── descriptions/              # 36 CWL tool definitions
├── portal_objects/
│   ├── workflows/            # 36 workflow metadata (YAML)
│   ├── metaworkflows/        # 7 complex pipeline definitions (YAML)
│   ├── file_reference.yaml   # Reference data metadata
│   └── software.yaml         # Software versions registry
├── dockerfiles/              # 13 tool container definitions
├── README.md
├── LICENSE                   # Apache 2.0
└── PIPELINE                  # Identifier
```

## Key CWL Patterns

### Docker Image Placeholders
All CWL files and Dockerfiles use `ACCOUNT/TOOL:VERSION` patterns that require substitution:
```yaml
hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/samtools:VERSION
```
These are replaced at deployment time with actual registry paths (e.g., `public.ecr.aws/smaht-dac/samtools:1.17`).

### File Staging and Renaming
Meta-workflow QC parsing uses `InitialWorkDirRequirement` to rename outputs from upstream tools before passing to parse-qc:
```yaml
entry: $(inputs.SAMTOOLS_stats_OUTPUT)
entryname: samtools.stats.txt
```
This allows parse-qc to locate expected input files by standardized names.

### Scatter Parallelization
Meta-workflows use scatter to process multiple inputs in parallel:
```yaml
scatter: 2  # Scatter on second dimension of dimensionality:2 arrays
```

### QC Ruleset Threshold Definitions
Thresholds use a pipe-delimited rule syntax:
```yaml
rule: Percentage Human Sequences [Kraken2]|>|95|0
```
This defines: metric_name | operator (>, <, ==, is_type) | threshold | tolerance

## Notes for Contributors

- All CWL and YAML files must follow consistent formatting conventions used in existing files
- Python scripts should use Click for CLI parsing and output structured formats (JSON for metrics)
- Dockerfile base image is `public.ecr.aws/smaht-dac/base-ubuntu2204-py38:0.0.1`; maintain compatibility
- Reference files (genomes, indexes, databases) are centrally managed; add new resources to `file_reference.yaml`
- Meta-workflow QC rulesets should follow the documented threshold syntax
- Tissue classifier model file (`tissue-classifier-model@v20241125`) should be updated when retraining occurs
