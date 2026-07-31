#!/usr/bin/env bash
# Remove common R package build artifacts from the FaultTree repo.
# Usage:
#   ./cleanup.sh
#   ./cleanup.sh --remove-tarballs --remove-rcheck

set -euo pipefail
cd "$(dirname "$0")"

REMOVE_TARBALLS=false
REMOVE_RCHECK=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remove-tarballs) REMOVE_TARBALLS=true; shift ;; 
    --remove-rcheck) REMOVE_RCHECK=true; shift ;; 
    -h|--help)
      cat <<'EOF'
Usage: ./cleanup.sh [OPTIONS]

Options:
  --remove-tarballs   Remove generated tar.gz/tgz archives
  --remove-rcheck     Remove the ..Rcheck directory
  -h, --help          Show this help message
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

paths=(
  "src/*.o"
  "src/*.obj"
  "src/*.dll"
  "src/*.rds"
  "R/.Rhistory"
  "*.html"
  "*~"
)

if [[ "$REMOVE_TARBALLS" == true ]]; then
  paths+=("*.tar.gz" "*.tgz" "*.zip")
fi
if [[ "$REMOVE_RCHECK" == true ]]; then
  paths+=("..Rcheck")
fi

echo "Cleaning repository build artifacts in $(pwd)"
for path in "${paths[@]}"; do
  shopt -s nullglob
  files=( $path )
  shopt -u nullglob
  if [[ ${#files[@]} -gt 0 ]]; then
    echo "Removing: $path"
    rm -rf "${files[@]}"
  fi
done

echo "Cleanup complete."
