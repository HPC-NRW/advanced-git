#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 -r REPO [-h]"
  echo "  -r REPO   The repository to create a new repository in (format: owner/repo)"
  echo "  -h        Show this help message"
  exit 1
}

repo=""
while getopts ":r:h" opt; do
  case "$opt" in
    r) repo="$OPTARG" ;;
    h) usage ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done

echo "Creating a new repository in the repository '$repo'..."
