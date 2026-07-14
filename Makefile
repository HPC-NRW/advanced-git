# variables
WORKING_DIR ?= files
REPO_NAME   ?= workshop-repo
REMOTE_REPO ?=
REPO_PATH   := $(WORKING_DIR)/$(REPO_NAME)


.PHONY: reset init-repo git-01-introduction git-02-branching git-03-remote git-03-remote-challenge git-04-undo


.ONESHELL:

reset:
	rm -rf $(REPO_PATH)

init-repo:
	mkdir -p $(REPO_PATH)
	cd $(REPO_PATH)
	git init -b main

# 01-introduction: git init, add, commit
git-01-introduction:
	init-repo
	cd $(REPO_PATH)
	printf '%s\n' "# Guacamole" "## Ingredients" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Add guacamole recipe"

# 02-branching: branch, switch, reformat recipe as YAML
git-02-branching:
	git-01-introduction
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
git-03-remote-challenge:
	git-03-remote
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
git-04-undo:
	git-03-remote-challenge
	cd $(REPO_PATH)
	printf '%s\n' "- Purchase the bean dip." >> bean-dip.md
	git add bean-dip.md
	git commit -m "Add bean dip recipe"

