# ==============================================================================
# RNAForge Docker Image
# Version: 1.0.0
# Description: Reproducible environment for the RNAForge Nextflow DSL2 pipeline
# ==============================================================================

FROM ubuntu:24.04

# ------------------------------------------------------------------------------
# OCI Metadata
# ------------------------------------------------------------------------------

LABEL org.opencontainers.image.title="RNAForge"
LABEL org.opencontainers.image.description="Modular Nextflow DSL2 RNA-seq analysis pipeline"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="Mohamed Elsisi"
LABEL org.opencontainers.image.vendor="Mohamed Elsisi"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/MohamedElsisii/RNAForge"

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/conda/bin:${PATH}"

SHELL ["/bin/bash", "-c"]
RUN conda list -n rnaforge > /opt/rnaforge-package-list.txt
# ------------------------------------------------------------------------------
# Install system dependencies
# ------------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        bzip2 \
        ca-certificates \
        curl \
        git \
        openjdk-17-jre-headless \
        procps \
        unzip \
        wget && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# Install Miniforge
# ------------------------------------------------------------------------------

ARG MINIFORGE_VERSION=25.3.1-0

RUN wget -q \
    "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-Linux-x86_64.sh" \
    -O Miniforge3.sh && \
    bash Miniforge3.sh -b -p /opt/conda && \
    rm Miniforge3.sh

# ------------------------------------------------------------------------------
# Configure Conda
# ------------------------------------------------------------------------------

RUN conda config --system --add channels conda-forge && \
    conda config --system --add channels bioconda && \
    conda config --system --set channel_priority strict

# ------------------------------------------------------------------------------
# Install RNAForge dependencies
# ------------------------------------------------------------------------------

COPY docker/environment.yml /tmp/environment.yml

RUN mamba env create \
        -f /tmp/environment.yml \
        -n rnaforge && \
    conda clean -afy

ENV PATH="/opt/conda/envs/rnaforge/bin:${PATH}"

# ------------------------------------------------------------------------------
# Working directory
# ------------------------------------------------------------------------------

RUN mkdir -p /workspace

WORKDIR /workspace

# ------------------------------------------------------------------------------
# Default command
# ------------------------------------------------------------------------------

CMD ["/bin/bash"]
