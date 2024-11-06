#!/bin/bash

INSTALL_LINK="https://install.determinate.systems/nix"

check_nix_installed() {
    if command -v nix &> /dev/null; then
        echo "Nix is already installed."
        return 0
    else
        return 1
    fi
}

if ! check_nix_installed; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl --proto '=https' --tlsv1.2 -sSf -L $INSTALL_LINK | sh -s -- install
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl --proto '=https' --tlsv1.2 -sSf -L $INSTALL_LINK | sh -s -- install macos
    else
        echo "Unsupported OS type: $OSTYPE"
        exit 1
    fi
fi

nix --version
nix develop
