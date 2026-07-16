# variables
WORKING_DIR ?= files
REPO_NAME   ?= workshop-repo
REMOTE_REPO ?=
UPSTREAM_REPO ?=
REPO_PATH   := $(WORKING_DIR)/$(REPO_NAME)


.PHONY: reset init-repo git-01-introduction git-02-branching git-03-remote git-03-remote-challenge git-04-undo


.ONESHELL:

reset:
	rm -rf $(REPO_PATH)

init-repo:
	mkdir -p $(REPO_PATH)

git-basic-03-create: init-repo
	cd $(REPO_PATH)
	mkdir recipes
	cd recipes
	git init
	git config --local user.name "Demo User"
	git config --local user.email "demo@email.com"

git-basic-04-tracking-changes: git-basic-03-create
	cd $(REPO_PATH)/recipes
	printf '%s\n' "# Guacamole" "## Ingredients" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Create initial structure for a Guacamole recipe"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado" "* lemon" "* salt" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Add ingredients for basic guacamole"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado" "* lime" "* salt" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Modify guacamole to the traditional recipe"
	touch cakes/brownie cakes/lemon_drizzle
	git add cakes
	git commit -m "Add some initial cakes"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado (1.35)" "* lime (0.64)" "* salt (2)" "## Instructions" > guacamole.md
	printf '%s\n' "# Market A" "* avocado: 1.35 per unit." "* lime: 0.64 per unit." "* salt: 2 per unit." > groceries.md
	git add guacamole.md groceries.md
	git commit -m "Write prices for ingredients and their source"
	git branch git-basic-05-exploring-history
	git branch git-basic-06-ignore

git-basic-06-ignore: git-basic-04-tracking-changes
	cd $(REPO_PATH)/recipes
	mkdir pictures
	touch a.png b.png c.png pictures/cake1.jpg pictures/cake2.jpg
	printf '%s\n' "*.png" "pictures/" > .gitignore
	git add .gitignore
	git commit -m "Ignore png files and the pictures folder."
	git branch git-basic-07-remotes
	git branch git-basic-08-collab

git-basic-08-collab: git-basic-06-ignore
	cd $(REPO_PATH)/recipes
	printf '%s\n' "# Hummus" "## Ingredients" "* chickpeas" "* lemon" "* olive oil" "* salt" > hummus.md
	git add hummus.md
	git commit -m "Add ingredients for hummus"
	git branch git-basic-09-conflict

git-basic-09-conflict: git-basic-08-collab
	cd $(REPO_PATH)/recipes
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado (1.35)" "* lime (0.64)" "* salt (2)" "## Instructions" "* peel the avocados and put them into a bowl."> guacamole.md
	git add guacamole.md
	git commit -m "Merge changes from remote repository"
	git branch git-adv-01-introduction

# 01-introduction: git init, add, commit
git-adv-01-introduction: git-basic-09-conflict
	cd $(REPO_PATH)
	printf '%s\n' "# Guacamole" "## Ingredients" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Add guacamole recipe"

# 02-branching: branch, switch, reformat recipe as YAML
git-02-branching: git-01-introduction
	cd $(REPO_PATH)
	git branch yaml-format
	git switch yaml-format
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		'instructions: ""' > guacamole.md
	git add guacamole.md
	git commit -m "Reformat recipe to use YAML."
	git switch main

# 03-remote (challenges excluded on purpose).
# Requires a real, already-created remote (REMOTE_REPO) - without it,this just switches back to `main` and does nothing else
git-03-remote: git-02-branching
	cd $(REPO_PATH)
	git switch main
	if [ -n "$(REMOTE_REPO)" ]; then
		git remote add origin "$(REMOTE_REPO)"
		# fetch first so refs/remotes/origin/* exists locally --
		# needed for the show-ref check below
		git fetch origin

		if git show-ref --verify --quiet refs/remotes/origin/main; then
			# remote has a README (or other commits) already --
			git branch --set-upstream-to=origin/main main
			git pull --allow-unrelated-histories --no-edit
			git push
		else
			# remote has no README / no commits yet, nothing to merge
			git push --set-upstream origin main
		fi
	fi

# 03-remote challenge
# 04-undo assumes this challenge already exists
# A participant who wants to attempt the challenge themselves should start from `git-03-remote` and do this part by hand instead
git-03-remote-challenge: git-03-remote
	cd $(REPO_PATH)
	git branch bean-dip
	git switch bean-dip
	printf '%s\n' "# Bean Dip" "## Ingredients" "- beans" "## Instructions" > bean-dip.md
	git add bean-dip.md
	git commit -m "Add bean dip recipe."
	if [ -n "$(REMOTE_REPO)" ]; then
		git push --set-upstream origin bean-dip
	fi

# 04-undo: a commit worth reverting/resetting live
git-04-undo: git-03-remote-challenge
	cd $(REPO_PATH)
	printf '%s\n' "- Purchase the bean dip." >> bean-dip.md
	git add bean-dip.md
	git commit -m "Add bean dip recipe"

# 05-merging: fast-forward merge, non-fast-forward merge, and a conflict to resolve live
# The exercises have no single solution, so they are excluded on purpose
git-05-merging: git-04-undo
	cd $(REPO_PATH)
	git checkout main
	git merge yaml-format
	git branch add-instructions
	git switch add-instructions
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		"instructions: |" \
		"  1. Cut avocados in half and remove pit." \
		"  2. Make guacamole." > guacamole.yaml
	git add guacamole.yaml
	git commit -m "Add instructions to guacamole recipe."
	git switch main
	git merge --no-ff add-instructions -m "Merge add-instructions branch into main."
	git branch modify-guac-instructions
	git switch modify-guac-instructions
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		"instructions: |" \
		"  1. Cut avocados in half and remove pit." \
		"  2. Slice the avocados and mash them with a fork." > guacamole.yaml
	git add guacamole.yaml
	git commit -m "Modify guacamole instructions to include mashing."
	git switch main
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		"instructions: |" \
		"  1. Cut avocados in half and remove pit." \
		"  2. Use a food processor to blend the avocados." > guacamole.yaml
	git add guacamole.yaml
	git commit -m "Modify guacamole instructions to include food processor."
	git merge modify-guac-instructions
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		"instructions: |" \
		"  1. Cut avocados in half and remove pit." \
		"  2. Use a food processor to blend the avocados, then mash by hand to finish." > guacamole.yaml
	git add guacamole.yaml
	git commit -m "Resolve merge conflict in guacamole.yaml."

# 05-merging exercise 1: fast-forward merge challenge (exercise 2 stays free-form, excluded)
git-05-merging-exercise-01: git-05-merging
	cd $(REPO_PATH)
	git branch finish-guac-recipe
	git switch finish-guac-recipe
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		"instructions: |" \
		"  1. Cut avocados in half and remove pit." \
		"  2. Mash avocados with a fork." \
		"  3. Add lime juice and salt to taste." > guacamole.yaml
	git add guacamole.yaml
	git commit -m "Add instructions to guacamole recipe."
	git switch main
	git merge finish-guac-recipe

# 06-tags: a lightweight tag and an annotated tag
git-06-tags: git-05-merging
	cd $(REPO_PATH)
	git tag 1.0.0
	git tag -a 2.0.0 -m "Second Release"
	if [ -n "$(REMOTE_REPO)" ]; then
		git push origin 1.0.0
		git push origin 2.0.0
	fi

# 09-forking: simulate the forking workflow via an `upstream` remote
# Requires REMOTE_REPO to already be a fork of UPSTREAM_REPO for the push/fetch steps to do anything
git-09-forking: git-06-tags
	cd $(REPO_PATH)
	git switch main
	if [ -n "$(UPSTREAM_REPO)" ]; then
		git remote add upstream "$(UPSTREAM_REPO)"
		git pull upstream main
		if [ -n "$(REMOTE_REPO)" ]; then
			git push --set-upstream origin main
		fi
	fi
	git branch myfeature
	git switch myfeature
	printf '%s\n' "# Chips" "## Ingredients" "## Instructions" > chips.md
	git add chips.md
	git commit -m "Add chips recipe"
	if [ -n "$(REMOTE_REPO)" ]; then
		git push --set-upstream origin myfeature
	fi
	git switch main

# 12-large-files: track a "large" file with git lfs
git-12-large-files: git-09-forking
	cd $(REPO_PATH)
	git switch main
	git lfs install
	echo "This is a very large report." > report.pdf
	git lfs track report.pdf
	git add .gitattributes
	git commit -m "Setup LFS tracking"
	git add report.pdf
	git commit -m "Add final report to the repository"
	if [ -n "$(REMOTE_REPO)" ]; then
		git push origin main
	fi

