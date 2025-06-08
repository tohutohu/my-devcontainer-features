#!/bin/sh
set -e

echo "Activating feature 'Development Tools'"

# Options
INSTALL_RG=${INSTALLRG:-true}
RG_VERSION=${RGVERSION:-latest}
INSTALL_AST_GREP=${INSTALLASTGREP:-true}
AST_GREP_VERSION=${ASTGREPVERSION:-latest}
INSTALL_SEMGREP=${INSTALLSEMGREP:-true}
SEMGREP_VERSION=${SEMGREPVERSION:-latest}

# Common functions
apt_get_update()
{
    if [ -z "$(find /var/lib/apt/lists -mindepth 1 -maxdepth 1 2>/dev/null)" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

# Install common dependencies
check_packages curl ca-certificates jq unzip

# Install ripgrep (rg) via apt
if [ "${INSTALL_RG}" = "true" ]; then
    echo "Installing ripgrep via apt..."
    check_packages ripgrep
    
    echo "ripgrep has been installed!"
    rg --version
fi

# Install ast-grep
if [ "${INSTALL_AST_GREP}" = "true" ]; then
    echo "Installing ast-grep ${AST_GREP_VERSION}..."
    
    # Get architecture
    architecture="$(dpkg --print-architecture)"
    case "${architecture}" in
        amd64) ast_arch="x86_64" ;;
        arm64) ast_arch="aarch64" ;;
        armhf) ast_arch="armv7" ;;
        *) echo "Unsupported architecture for ast-grep: ${architecture}" && INSTALL_AST_GREP="false" ;;
    esac
    
    if [ "${INSTALL_AST_GREP}" = "true" ]; then
        if [ "${AST_GREP_VERSION}" = "latest" ]; then
            AST_GREP_VERSION=$(curl -s https://api.github.com/repos/ast-grep/ast-grep/releases/latest | jq -r '.tag_name')
            echo "Latest ast-grep version: ${AST_GREP_VERSION}"
        fi
        
        ast_download_url="https://github.com/ast-grep/ast-grep/releases/download/${AST_GREP_VERSION}/app-${ast_arch}-unknown-linux-gnu.zip"
        
        echo "Downloading from: ${ast_download_url}"
        curl -sL "${ast_download_url}" -o /tmp/ast-grep.zip
        unzip -q /tmp/ast-grep.zip -d /tmp/ast-grep
        mv /tmp/ast-grep/sg /usr/local/bin/ast-grep
        rm -rf /tmp/ast-grep.zip /tmp/ast-grep
        chmod +x /usr/local/bin/ast-grep
        
        # Create sg symlink for convenience
        ln -sf /usr/local/bin/ast-grep /usr/local/bin/sg
        
        echo "ast-grep has been installed!"
        ast-grep --version
    fi
fi

# Install semgrep via pip
if [ "${INSTALL_SEMGREP}" = "true" ]; then
    echo "Installing semgrep ${SEMGREP_VERSION}..."
    
    # Install python3 and pip if not already installed
    echo "Installing Python dependencies..."
    check_packages python3 python3-pip
    
    # Install semgrep globally via pip
    echo "Installing semgrep..."
    if [ "${SEMGREP_VERSION}" = "latest" ]; then
        pip3 install --upgrade pip
        pip3 install semgrep
    else
        pip3 install --upgrade pip
        pip3 install semgrep==${SEMGREP_VERSION}
    fi
    
    echo "semgrep has been installed!"
    semgrep --version
fi

echo "Development tools installation completed!"