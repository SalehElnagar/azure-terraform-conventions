#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
cd "$ROOT_DIR"

cleanup_files() {
  local pattern=$1
  find . -type f -name "$pattern" -print0 | xargs -0 rm -f
}

cleanup_dirs() {
  local name=$1
  find . -type d -name "$name" -print0 | xargs -0 rm -rf
}

# remove Terraform state files and their backups
cleanup_files '*.tfstate'
cleanup_files '*.tfstate.*'

# remove Terraform plan files
cleanup_files '*.tfplan'

# remove Terraform working directories
cleanup_dirs '.terraform'

echo "Terraform artefacts removed from $(pwd)"
