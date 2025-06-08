#!/bin/bash

set -e

source dev-container-features-test-lib

check "rgがインストールされている" bash -c "which rg"
check "rgのバージョン確認" bash -c "rg --version"

check "ast-grepがインストールされている" bash -c "which ast-grep"
check "sgコマンドが使える" bash -c "which sg"
check "ast-grepのバージョン確認" bash -c "ast-grep --version"

check "semgrepがインストールされている" bash -c "which semgrep"
check "semgrepのバージョン確認" bash -c "semgrep --version"

check "Denoがインストールされている" bash -c "which deno"
check "Denoのバージョン確認" bash -c "deno --version"

reportResults