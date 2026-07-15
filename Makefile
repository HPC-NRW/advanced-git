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
	cd $(REPO_PATH)
	git init -b main

# 01-introduction: git init, add, commit
git-01-introduction: init-repo
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

# 02-branching challenge: rename guacamole.md to guacamole.yaml on the yaml-format branch
git-02-branching-challenge-01: git-02-branching
	cd $(REPO_PATH)
	git switch yaml-format
	git mv guacamole.md guacamole.yaml
	git commit -m "Rename recipe file to use .yaml extension."
	git switch main

# 02-branching challenge: rename yaml-format to feature/yaml-format
git-02-branching-challenge-02: git-02-branching
	cd $(REPO_PATH)
	git branch -m yaml-format feature/yaml-format

# 02-branching challenge: create an unmerged branch, then delete it (-d fails, -D forces it)
git-02-branching-challenge-03: git-02-branching
	cd $(REPO_PATH)
	git switch main
	git switch -c dessert-recipes
	printf '%s\n' "# Chocolate Chip Cookies" "## Ingredients" "## Instructions" > cookies.md
	git add cookies.md
	git commit -m "Add chocolate chip cookies recipe."
	git switch main
	git branch -D dessert-recipes

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

# 13-cherrypick: cherry-pick a commit from bean-dip into main
git-13-cherrypick: git-12-large-files
	cd $(REPO_PATH)
	git switch bean-dip
	printf '%s\n' \
		"# Market A" \
		"* avocado: 1.35 per unit." \
		"* lime: 0.64 per unit" \
		"* salt: 2 per kg" \
		"* black beans: 0.99 per can" > groceries.md
	git add groceries.md
	git commit -m "Add bean dip ingredients to groceries"
	if [ -n "$(REMOTE_REPO)" ]; then
		git push
	fi
	git checkout main
	git cherry-pick bean-dip
	if [ -n "$(REMOTE_REPO)" ]; then
		git push
	fi

# 13-cherrypick exercise: create a cookies branch, cherry-pick just the groceries.md change into main
git-13-cherrypick-exercise-01: git-13-cherrypick
	cd $(REPO_PATH)
	git switch main
	git branch cookies
	git switch cookies
	mkdir -p cookies
	printf '%s\n' "# Chocolate Chip Cookies" "## Ingredients" "## Instructions" > cookies/chocolate-chip-cookies.md
	git add cookies/chocolate-chip-cookies.md
	git commit -m "Add chocolate chip cookies recipe"
	printf '%s\n' "* chocolate chips: 3.49 per bag" >> groceries.md
	git add groceries.md
	git commit -m "Add chocolate chips to groceries"
	printf '%s\n' \
		"1. Cream the butter and sugar." \
		"2. Mix in the chocolate chips." \
		"3. Bake at 375F for 10 minutes." >> cookies/chocolate-chip-cookies.md
	git add cookies/chocolate-chip-cookies.md
	git commit -m "Add instructions to chocolate chip cookies recipe"
	git switch main
	git cherry-pick cookies~1

# 13-cherrypick exercise: cherry-pick a range of 2 commits touching groceries.md
git-13-cherrypick-exercise-02: git-13-cherrypick-exercise-01
	cd $(REPO_PATH)
	git switch cookies
	printf '%s\n' "# Sugar Cookies" "## Ingredients" "- sugar: 200g" "- flour: 300g" "- butter: 150g" "## Instructions" > cookies/sugar-cookies.md
	git add cookies/sugar-cookies.md
	git commit -m "Add sugar cookies recipe"
	printf '%s\n' "* sugar: 1.20 per kg" >> groceries.md
	git add groceries.md
	git commit -m "Add sugar to groceries"
	printf '%s\n' "* flour: 2.50 per kg" "* butter: 3.00 per kg" >> groceries.md
	git add groceries.md
	git commit -m "Add flour and butter to groceries"
	printf '%s\n' \
		"1. Cream the butter and sugar." \
		"2. Mix in the flour." \
		"3. Bake at 350F for 12 minutes." >> cookies/sugar-cookies.md
	git add cookies/sugar-cookies.md
	git commit -m "Add instructions to sugar cookies recipe"
	git switch main
	git cherry-pick cookies~3..cookies~1

# 13-cherrypick exercise: cherry-pick from a local "upstream" remote - a single commit, then a PR merge commit
git-13-cherrypick-exercise-upstream: git-13-cherrypick
	rm -rf $(WORKING_DIR)/upstream-cherry
	mkdir -p $(WORKING_DIR)/upstream-cherry
	cd $(WORKING_DIR)/upstream-cherry
	git init -q -b master
	printf '%s\n' "# Toast" "## Ingredients" "- bread" > toast.md
	git add toast.md
	git commit -q -m "Add toast recipe"
	git branch add-butter
	git switch -q add-butter
	printf '%s\n' "# Toast" "## Ingredients" "- bread" "- butter" > toast.md
	git add toast.md
	git commit -q -m "Add butter to toast"
	git switch -q master
	git merge --no-ff add-butter -m "Merge pull request #42 from upstream-org/add-butter" -q
	cd ../$(REPO_NAME)
	git branch develop main
	git checkout -b cherry develop
	git remote remove upstream 2>/dev/null || true
	git remote add upstream ../upstream-cherry
	git fetch upstream master
	git cherry-pick upstream/master~1
	git cherry-pick -m 1 --no-edit upstream/master

# 13-cherrypick exercise: revert the PR merge commit we just cherry-picked, hard-reset it away, then redo a commit via reset+recommit
git-13-cherrypick-exercise-undoing-commits: git-13-cherrypick-exercise-upstream
	cd $(REPO_PATH)
	git switch cherry
	git revert -m 1 --no-edit HEAD
	git reset HEAD~2 --hard
	git reset HEAD~1
	git add toast.md
	git commit -m "Add toast recipe"

# 14-squash-rebase: build a messy commit history on `pie-recipes` for a live interactive rebase demo
git-14-squash-rebase: git-13-cherrypick
	cd $(REPO_PATH)
	git branch pie-recipes
	git switch pie-recipes
	printf '%s\n' "# Pie Recipes" > pie-recipes.md
	git add pie-recipes.md
	git commit -m "Initial commit with recipe files"
	printf '%s\n' "" "## Apple Pie" "### Ingredients" "- apples" "### Instructions" >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Add Apple Pie recipe"
	printf '%s\n' "" "## Pecan Pie" "### Ingredients" "- pecens" "- corn syrup" >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Add recipe for Pecan Pie with ingredients"
	sed -i 's/pecens/pecans/' pie-recipes.md
	git add pie-recipes.md
	git commit -m "Fix typo in ingredients"
	printf '%s\n' "### Instructions" "1. Preheat oven to 350F." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Additional instructions to pecan pie recipe"
	printf '%s\n' "2. Bake for 45 minutes." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Complete pecan pie recipe instructions"
	if [ -n "$(REMOTE_REPO)" ]; then
		git push --set-upstream origin pie-recipes
	fi

# 14-squash-rebase exercise 2: 3 commits (one with a typo'd message), fixed via non-interactive amend
git-14-squash-rebase-exercise-02: git-14-squash-rebase
	cd $(REPO_PATH)
	git switch main
	printf '%s\n' "flour" > pancake.md
	git add pancake.md
	git commit -m "Add flour"
	printf '%s\n' "milk" >> pancake.md
	git add pancake.md
	git commit -m "Add milk"
	printf '%s\n' "egg" >> pancake.md
	git add pancake.md
	git commit -m "Add eg"
	git commit --amend -m "Add egg"

# 15-hooks-actions: a pre-commit hook running flake8, plus a file with an intentional lint error
# Committing hello.py (and watching the hook block it) is demoed live
git-15-hooks-actions: git-14-squash-rebase
	cd $(REPO_PATH)
	git switch main
	pip install flake8
	printf '%s\n' \
		"#!/usr/bin/env bash" \
		"" \
		"set -eo pipefail" \
		"flake8 hello.py" \
		"echo \"flake8 passed!\"" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	printf '%s\n' "print('Hello world!'')" > hello.py

# 15-hooks-actions exercise 1 (Challenge 1): a commit-msg hook enforcing feat:/fix:/docs: prefixes
# pre-commit is temporarily moved aside so the flake8/hello.py failure doesn't mask this hook's own test
git-15-hooks-actions-challenge-01: git-15-hooks-actions
	cd $(REPO_PATH)
	printf '%s\n' \
		"commit_msg=\$$(cat \"\$$1\")" \
		"" \
		"if ! echo \"\$$commit_msg\" | grep -qE \"^(feat|fix|docs):\"; then" \
		"    echo \"ERROR: Commit message must start with 'feat:', 'fix:' or 'docs:'\"" \
		"    exit 1" \
		"fi" > .git/hooks/commit-msg
	chmod +x .git/hooks/commit-msg
	mv .git/hooks/pre-commit .git/hooks/pre-commit.bak
	printf '%s\n' "test file" > testfile.txt
	git add testfile.txt
	git commit -m "updated stuff"
	git commit -m "feat: add test file"
	mv .git/hooks/pre-commit.bak .git/hooks/pre-commit
