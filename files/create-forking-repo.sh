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

echo "Creating and pushing content to'$repo'..."

# Create a temporary directory for us to add content to
dir_name="$(mktemp -d)"
mkdir -p "$dir_name"

# Move to the newly created directory and initialize a git repository
cd "$dir_name"
git init

# Create a README file
cat > README.md <<README_EOF
# README

This repository is created to demonstrate how to work with a forking workflow in git.

## Instructions

1. Create a fork of this repository on GitLab.
2. Clone your fork to your local machine.
3. Make changes to a file.
4. Commit and push your changes to your fork.
5. Create a merge request to propose your changes to the original repository.
README_EOF

# Create some files for content
cat > guacamole.md <<GUACAMOLE_EOF
# Guacamole
## Ingredients
* avocado (1.35)
* lime (0.64)
* salt (2)
## Instructions
* mash avocado
* add lime juice
* add salt
GUACAMOLE_EOF

cat > bean-dip.md <<BEAN_DIP_EOF
# Bean Dip
## Ingredients
* black beans (2)
## Instructions
* mash beans
BEAN_DIP_EOF

cat > salsa.md <<SALSA_EOF
# Salsa
## Ingredients
* tomatoes (3)
* onion (1)
* cilantro (0.5)
* jalapeno (1)
## Instructions
SALSA_EOF

mkdir cakes

cat > cakes/chocolate-cake.md <<CHOCOLATE_CAKE_EOF
# Chocolate Cake
## Ingredients
## Instructions
CHOCOLATE_CAKE_EOF

mkdir pies

cat > pies/apple-pie.md <<APPLE_PIE_EOF
# Apple Pie
## Ingredients
* apples (5)
## Instructions
APPLE_PIE_EOF

cat > pies/pecan-pie.md <<PECAN_PIE_EOF
# Pecan Pie
## Ingredients
## Instructions
PECAN_PIE_EOF

# Stage and commit the files
git add .
git commit -m "Initial commit with recipe files"
# Add the remote repository
git remote add origin "$repo"
# Push the content to the remote repository
git branch -M main
git push -u origin main

echo "Content pushed to '$repo' successfully."

# Clean up the temporary directory
cd ..
rm -rf "$dir_name"

echo "Temporary directory cleaned up."
echo "Done."
