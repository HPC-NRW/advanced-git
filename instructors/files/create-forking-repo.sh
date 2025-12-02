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

This repository is created to demonstrate how to work with a repository in git.

It is based off of a recipe collection, and contains commits and branches intended to provide
interactive practice for various git techniques.

## Elements
- A branch for practicing cherry-picking (`sadies-recipes`)
- Multiple commits modifying the same file, incorporating an mistake to be fixed via interactive rebase (`pecan-pie-recipe`)
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
git push -u origin main --force

# Make a branch off of main to use for cherrypicking practice
git checkout -b sadies-recipes
cat > cakes/chocolate-cake.md <<CHOCOLATE_CAKE_EOF
# Sadie's Chocolate Cake
## Ingredients
- eggs (3)
- butter (150g)
- flour (225 ml)
- sugar (300 ml)
- vanilla sugar (1 tsp)
- cocoa powder (6 tbsp)
## Instructions
CHOCOLATE_CAKE_EOF
git add cakes/chocolate-cake.md
git commit -m "Update chocolate cake recipe to Sadie's version"

cat > pies/apple-pie.md <<APPLE_PIE_EOF
# Sadie's Apple Pie
## Ingredients
* apples (5)
* cinnamon (1 tsp)
* sugar (100 ml)
## Instructions
APPLE_PIE_EOF
git add pies/apple-pie.md
git commit -m "Update apple pie recipe to Sadie's version"

git push -u origin sadies-recipes --force

git checkout main

# Make multiple commits modifying the same file to allow for interactive rebase practice
git checkout -b pie-recipes

cat > pies/apple-pie.md <<APPLE_PIE_EOF
# Apple Pie
## Ingredients
- sugar (1c)
- apples (5)
- cinnamon (1 tsp)
## Instructions
- Preheat the oven to 200°C (400°F).
- Make the pie.
APPLE_PIE_EOF
git add pies/apple-pie.md
git commit -m "Add Apple Pie recipe"

cat > pies/pecan-pie.md <<PECAN_PIE_EOF
# Pecan Pie
## Ingredients
- sugar (1c)
- borwn sugar (3tbsp)
- salt (1/2 tsp)
- corn syrup (1c)
- eggs (3)
- butter (1/3c)
- vanilla extract (1 tsp)
- pecans (1c)
## Instructions
PECAN_PIE_EOF
git add pies/pecan-pie.md
git commit -m "Add recipe for Pecan Pie with ingredients"

sed -i 's/borwn sugar/brown sugar/' pies/pecan-pie.md
git add pies/pecan-pie.md
git commit -m "Fix typo in ingredients"

echo "- Preheat the oven to 175°C (350°F)." >> pies/pecan-pie.md
echo "- Mix everything in a large bowl." >> pies/pecan-pie.md
echo "- Pour into a pie crust." >> pies/pecan-pie.md
git add pies/pecan-pie.md
git commit -m "Additional instructions to pecan pie recipe"

echo "- Bake for 20 minutes with foil on top, then 30 minutes uncovered." >> pies/pecan-pie.md
git add pies/pecan-pie.md
git commit -m "Complete pecan pie recipe instructions"

git push -u origin pie-recipes --force

# Return to main branch
git checkout main

# Add more changes to main to ensure pecan-pie-recipe is behind main
cat > salsa.md <<SALSA_EOF
# Salsa
## Ingredients
* tomatoes (4)
* onion (1)
* cilantro (50g)
* jalapeno (1)
## Instructions
* chop all ingredients and mix together
SALSA_EOF

git add salsa.md
git commit -m "Update salsa recipe with correct tomato quantity"

cat > pies/pecan-pie.md <<PECAN_PIE_EOF
# Pecan Pie
NOTE: Ask Lisa for her recipe
## Ingredients
## Instructions
PECAN_PIE_EOF

git add pies/pecan-pie.md
git commit -m "Add note to ask Lisa for her pecan pie recipe"

git push -u origin main --force

echo "Content pushed to '$repo' successfully."

# Clean up the temporary directory
cd ..
rm -rf "$dir_name"

echo "Temporary directory cleaned up."
echo "Done."

# git fetch origin --prune && git reset --hard origin/main && git clean -fd && git branch | grep -v "main" | xargs git branch -D 2>/dev/null; git branch -r | grep -v '\->' | sed 's/origin\///' | grep -v "main" | xargs -I {} git checkout --track origin/{} && git checkout main
