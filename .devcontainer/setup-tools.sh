#!/usr/bin/env bash
set -euo pipefail

# OSS CAD Suite
TOOLS_DIR="/opt/oss-cad-suite"
if [ ! -d "$TOOLS_DIR" ]; then
    wget -O /tmp/oss-cad-suite.tgz \
      https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-03-07/oss-cad-suite-linux-x64-20260307.tgz
    tar -xzf /tmp/oss-cad-suite.tgz -C /tmp
    sudo mv /tmp/oss-cad-suite "$TOOLS_DIR"
    rm /tmp/oss-cad-suite.tgz
fi

# Put both toolchains on PATH for future shells
if ! grep -q 'teros-python/bin' /home/vscode/.bashrc; then
    echo 'export PATH=/opt/teros-python/bin:/opt/oss-cad-suite/bin:$PATH' >> /home/vscode/.bashrc
fi

export PATH=/opt/teros-python/bin:/opt/oss-cad-suite/bin:$PATH


# setup the .teroshdl/build directory as a symlink to the build directory in the home folder
mkdir -p /home/vscode/.teroshdl/build
ln -sfn /home/vscode/.teroshdl/build "$PWD/build"

# copy teroshdl global settings
cp "$PWD/.devcontainer/teros-settings.json" /home/vscode/.teroshdl2_config.json

yosys -V
ghdl --version
yosys -p "help ghdl" >/dev/null || echo "WARNING: yosys-ghdl plugin not detected"
echo "Setup complete ! You can work now on the exercises"