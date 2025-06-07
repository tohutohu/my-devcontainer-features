#!/bin/sh
set -e

echo "Activating feature 'Development Tools'"
set -x  # Enable debug mode

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

# Get architecture
architecture="$(dpkg --print-architecture)"

# Install ripgrep (rg)
if [ "${INSTALL_RG}" = "true" ]; then
    echo "Installing ripgrep ${RG_VERSION}..."
    
    case "${architecture}" in
        amd64) rg_arch="x86_64" ;;
        arm64) rg_arch="aarch64" ;;
        armhf) rg_arch="arm" ;;
        i386) rg_arch="i686" ;;
        *) echo "Unsupported architecture for ripgrep: ${architecture}" && INSTALL_RG="false" ;;
    esac
    
    if [ "${INSTALL_RG}" = "true" ]; then
        if [ "${RG_VERSION}" = "latest" ]; then
            rg_download_url="https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-${rg_arch}-unknown-linux-musl.tar.gz"
        else
            rg_download_url="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-${rg_arch}-unknown-linux-musl.tar.gz"
        fi
        
        curl -sL "${rg_download_url}" | tar xz -C /tmp
        if [ "${RG_VERSION}" = "latest" ]; then
            mv /tmp/ripgrep-*/rg /usr/local/bin/
        else
            mv /tmp/ripgrep-${RG_VERSION}-${rg_arch}-unknown-linux-musl/rg /usr/local/bin/
        fi
        chmod +x /usr/local/bin/rg
        
        echo "ripgrep has been installed!"
        rg --version
    fi
fi

# Install ast-grep
if [ "${INSTALL_AST_GREP}" = "true" ]; then
    echo "Installing ast-grep ${AST_GREP_VERSION}..."
    
    case "${architecture}" in
        amd64) ast_arch="x86_64" ;;
        arm64) ast_arch="aarch64" ;;
        armhf) ast_arch="armv7" ;;
        *) echo "Unsupported architecture for ast-grep: ${architecture}" && INSTALL_AST_GREP="false" ;;
    esac
    
    if [ "${INSTALL_AST_GREP}" = "true" ]; then
        if [ "${AST_GREP_VERSION}" = "latest" ]; then
            ast_download_url="https://github.com/ast-grep/ast-grep/releases/latest/download/sg-${ast_arch}-unknown-linux-gnu.tar.gz"
        else
            ast_download_url="https://github.com/ast-grep/ast-grep/releases/download/${AST_GREP_VERSION}/sg-${ast_arch}-unknown-linux-gnu.tar.gz"
        fi
        
        curl -sL "${ast_download_url}" | tar xz -C /tmp
        mv /tmp/sg /usr/local/bin/ast-grep
        chmod +x /usr/local/bin/ast-grep
        
        # Create sg symlink for convenience
        ln -sf /usr/local/bin/ast-grep /usr/local/bin/sg
        
        echo "ast-grep has been installed!"
        ast-grep --version
    fi
fi

# Install semgrep
if [ "${INSTALL_SEMGREP}" = "true" ]; then
    echo "Installing semgrep ${SEMGREP_VERSION}..."
    
    # Install python3 and pip if not already installed
    echo "Installing Python dependencies..."
    check_packages python3 python3-pip python3-venv
    
    # Create a virtual environment for semgrep to avoid conflicts
    python3 -m venv /opt/semgrep-env
    
    # Activate virtual environment and install semgrep
    echo "Installing semgrep in virtual environment..."
    if [ "${SEMGREP_VERSION}" = "latest" ]; then
        /opt/semgrep-env/bin/pip install --upgrade pip
        /opt/semgrep-env/bin/pip install semgrep
    else
        /opt/semgrep-env/bin/pip install --upgrade pip
        /opt/semgrep-env/bin/pip install semgrep==${SEMGREP_VERSION}
    fi
    
    # Create symlink to make semgrep available globally
    ln -sf /opt/semgrep-env/bin/semgrep /usr/local/bin/semgrep
    
    echo "semgrep has been installed!"
    semgrep --version
fi

set +x  # Disable debug mode
echo "Development tools installation completed!"