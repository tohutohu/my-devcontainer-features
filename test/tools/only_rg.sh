#!/bin/bash

set -e

source dev-container-features-test-lib

check "rgがインストールされている" bash -c "which rg"
check "rgのバージョン確認" bash -c "rg --version"

check "ast-grepがインストールされていない" bash -c "! which ast-grep"
check "sgコマンドが使えない" bash -c "! which sg"

check "semgrepがインストールされていない" bash -c "! which semgrep"

reportResults