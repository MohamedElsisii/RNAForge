# RNAForge

> **A modular, reproducible, and scalable Nextflow DSL2 pipeline for
> RNA-seq analysis**

<img width="1254" height="1254" alt="RNAForge" src="https://github.com/user-attachments/assets/5546a879-0962-4610-b038-fc09aa094f25" />


![Nextflow](https://img.shields.io/badge/Nextflow-DSL2-23aa62?logo=nextflow)
![Docker](https://img.shields.io/badge/Docker-Supported-2496ED?logo=docker)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

------------------------------------------------------------------------

## Overview

RNAForge is a modular RNA-seq workflow written in **Nextflow DSL2**
designed to provide reproducible, scalable and maintainable
transcriptomic analysis from raw FASTQ files to quantified gene
expression.

### Features

-   Modular Nextflow DSL2 architecture
-   Docker / Apptainer ready
-   Automatic reference management
-   Supports paired-end and single-end data
-   FastQC quality control
-   Optional trimming
-   Multiple aligners:
    -   HISAT2
    -   Bowtie2
    -   BWA
-   SAMtools post-processing
-   featureCounts quantification
-   Reproducible execution
-   Local, HPC and cloud compatible

------------------------------------------------------------------------

# Workflow

``` text
FASTQ
  │
Sample Sheet
  │
Input Validation
  │
FastQC
  │
(Optional)
Cutadapt / Trimmomatic
  │
Alignment
(HISAT2 | Bowtie2 | BWA)
  │
SAMtools
Sort → Index
  │
featureCounts
  │
Reports + Counts
```

------------------------------------------------------------------------

# Repository Structure

``` text
RNAForge/
├── lib/
├── modules/
│   ├── alignment/
│   ├── input/
│   ├── post_alignment/
│   ├── qc/
│   ├── quantification/
│   ├── reference/
│   └── trimming/
├── scripts/
├── subworkflows/
├── main.nf
├── nextflow.config
├── README.md
├── LICENSE
└── .gitignore
```

------------------------------------------------------------------------

# Requirements

-   Linux
-   Java 17+
-   Nextflow
-   Docker or Apptainer (recommended)

------------------------------------------------------------------------

# Installation

``` bash
git clone https://github.com/MohamedElsisii/RNAForge.git
cd RNAForge
```

Install Nextflow:

``` bash
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
```

------------------------------------------------------------------------

# Quick Start

``` bash
nextflow run main.nf \
    --input samples.csv \
    --genome hg38 \
    --aligner hisat2
```

Run using Docker:

``` bash
nextflow run main.nf \
    -profile docker
```

------------------------------------------------------------------------

# Supported Aligners

  Aligner   Status
  --------- --------
  HISAT2    ✅
  Bowtie2   ✅
  BWA       ✅

------------------------------------------------------------------------

# Output

``` text
results/
├── fastqc/
├── trimmed/
├── alignment/
├── bam/
├── counts/
└── reports/
```

------------------------------------------------------------------------

# Reproducibility

RNAForge uses:

-   Nextflow DSL2
-   Container support
-   Version-controlled workflow
-   Deterministic execution
-   Resume functionality

------------------------------------------------------------------------

# Docker

``` bash
nextflow run main.nf -profile docker
```

------------------------------------------------------------------------

# HPC

Example:

``` bash
nextflow run main.nf -profile slurm
```

------------------------------------------------------------------------

# Parameters

  Parameter   Description
  ----------- --------------------
  --input     Sample sheet
  --genome    Reference genome
  --aligner   Alignment software
  --outdir    Output directory

------------------------------------------------------------------------

# Citation

If you use RNAForge, please cite the repository and any future
publication.

A `CITATION.cff` file will be provided.

------------------------------------------------------------------------

# Contributing

Contributions are welcome.

1.  Fork
2.  Create feature branch
3.  Commit
4.  Pull request


------------------------------------------------------------------------

# License

Released under the MIT License.

------------------------------------------------------------------------

# Contact

**Mohamed Elsisi**

GitHub: https://github.com/MohamedElsisii

------------------------------------------------------------------------

## Acknowledgements

RNAForge builds upon the excellent ecosystems surrounding Nextflow,
Docker, SAMtools, FastQC, featureCounts, HISAT2, STAR, Bowtie2 and the
broader open-source bioinformatics community.
