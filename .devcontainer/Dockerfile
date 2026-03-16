FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    wget \
    xz-utils \
    python3 \
    python3-pip \
    python3-venv \
    ghdl \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/teros-python && \
    /opt/teros-python/bin/pip install --upgrade pip setuptools wheel && \
    /opt/teros-python/bin/pip install edalize vunit-hdl yowasp-yosys cocotb

ENV PATH="/opt/teros-python/bin:/opt/oss-cad-suite/bin:${PATH}"