#!/bin/bash

set -e

source dev-container-features-test-lib

check "rgのバージョンが14.1.0" bash -c "rg --version | grep '14.1.0'"
check "ast-grepのバージョンが0.12.0" bash -c "ast-grep --version | grep '0.12.0'"
check "semgrepのバージョンが1.45.0" bash -c "semgrep --version | grep '1.45.0'"

reportResults