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
check_packages curl ca-certificates

# Install ripgrep (rg) via apt
if [ "${INSTALL_RG}" = "true" ]; then
    echo "Installing ripgrep via apt..."
    check_packages ripgrep
    
    echo "ripgrep has been installed!"
    rg --version
fi

# Install ast-grep via npm
if [ "${INSTALL_AST_GREP}" = "true" ]; then
    echo "Installing ast-grep ${AST_GREP_VERSION}..."
    
    # Install Node.js if not already installed
    if ! command -v npm >/dev/null 2>&1; then
        echo "Installing Node.js..."
        check_packages nodejs npm
    fi
    
    # Install ast-grep globally via npm
    if [ "${AST_GREP_VERSION}" = "latest" ]; then
        npm install -g @ast-grep/cli
    else
        npm install -g @ast-grep/cli@${AST_GREP_VERSION}
    fi
    
    # Create sg symlink for convenience
    ln -sf /usr/local/bin/ast-grep /usr/local/bin/sg
    
    echo "ast-grep has been installed!"
    ast-grep --version
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