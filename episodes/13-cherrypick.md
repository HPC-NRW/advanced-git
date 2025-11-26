---
title: "Undo, Move, Cherrypick"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::::: questions

- How to undo changes to a repository?
- How to rename a branch?
- How to incoproate specific changes in one branch into another?

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: objectives

- Learn how to undo a specific commit.
- Learn to rename an existing branch.
- Learn to pick and incorporate specific changes into a different branch.

::::::::::::::::::::::::::::::::::::::::::::::::::

# I made a mistake! How do I undo a commit?

If you made a commit and then realize that you made a mistake, you can undo the commit using
the `git reset` command. This command moves the branch pointer back to a previous commit,
effectively removing the most recent commit(s) from the branch.

The syntax for the `git reset` command looks like this:

```bash
git reset <mode> <commit>
```

The `<mode>` refers to how the command should handle changes to the working branch and staging area.
The most common modes are:


- `--mixed`: This is the default mode if you do not provide one. The changes from the undone
  commits are kept in the working directory, but are removed from the staging area.
- `--soft`: The changes from the undone commit(s) are kept in the staging area, as though you had
  just run `git add` on those changes.
- `--hard`: The changes from the undone commit(s) are removed from both the working directory and
  the staging area, effectively discarding them in total. (Use with caution, as this cannot be
  undone!)

The `<commit>` refers to the commit that you want to reset the branch to. You can specify this
using the specific commit hash you want to reset to, or you can use relative references like
`HEAD~2` (which refers to the commit two before the current HEAD).

::: challenge
## Undo a staged change.

Stage a specific change and then take it back.

:::: hint
tbd.
::::

:::: solution
tbd.
::::

:::


::: challenge
## Undo the last commit

:::: hint
tbd.
::::

:::: solution
tbd.
::::

:::
# I don't like the name of my branch! How do I rename it?

You can rename a branch using the `git branch -m` command. The syntax looks like this:

```bash
git branch -m <new-branch-name>
```

This will rename the current branch to the new name provided. If you want to rename a different
branch, without checking it out you can provide the old branch name as well:

```bash
git branch -m <old-branch-name> <new-branch-name>
```

# I need that commit also in my branch. How do I get it?

If there is a specific change present in a different branch that you need in another branch, Git
lets you "cherrypick" those commits. The "cherrypick" command is a way of copying a specific commit
from one branch to another. Each commit in git has a specific identifier (the "hash" or "SHA" of
the commit) that we can use to refer to that exact commit. You can see the hash of your recent
commits by running:

```bash
git log --oneline
```

Note that this only shows the commits that are present on this "branch". If you want to see commits
from all branches, you can run:

```bash
git log --oneline --all
```

or checkout the specific branch you want to see.

So why would I want to cherrypick a commit?

- Imagine you have a branch where you are working on a new feature. You make several commits to
  this branch, but as you work you realize that one of the commits you just made would be
  important to include in the "main" branch right away.
- Or maybe you're working on a branch and realize that the commit you just made would be better
  suited to a different branch.
- Or maybe you have a branch with several commits, but you realize that you want to split these out
  into one or more branches.

::: callout
The more confined and specific commits are, the better they can be cherry-picked.
:::

In these cases, you can use "cherrypick" to move a specific commit from one branch to another.

## How to Cherrypick

The `cherrypick` command looks like this:

```bash
git cherry-pick <commit-hash>
```

Note that we don't have to provide any information about the source branch, because the commit
hashes are unique across the entire repository. Git will find the commit with the specified hash,
then apply it to the current branch. This means if we want to move a commit from, as in our
example, a feature branch to the main branch, we first need to checkout the main branch:

```bash
git checkout main
git cherry-pick <commit-hash>
```

The command will then apply the changes only from the specified commit to the current branch,
creating a new commit with those changes.

## Undoing a Cherrypick

If you cherrypick a commit and then realize that you made a mistake, you can undo the cherrypick
using the `git reset` command we showed earlier:

```bash
git reset --hard HEAD~1
```

## Issues with Cherrypick

Cherrypicking is an infrequent operation, and it can lead to some issues if not used carefully.
Some things to keep in mind:

- You are creating a new commit on the branch, which means that if the original commit is later
  merged into the branch, you may end up with a merge conflict.
- If the commit you are cherrypicking depends on other commits that are not present in the target
  branch, you may run into issues when trying to apply the changes or run the code.
- The new commit will look identical to the old commit, but with a different hash. This can make
  it difficult to visually track changes across branches.

::: challenge

## Cherry-picking a hotfix into a branch

An urgend fix to main is also needed in a release branch to issue a bugfix
release.

1. Create a branch off main and add a commit.
2. Switch back to main and add a commit there, too.
3. Switch back to your newly created branch and cherry-pick the last commit
   from main to the branch.

:::: hint
tbd.
::::
:::: solution
tbd.
::::

:::

![GitFlow 1](fig/43-undo.png)
![GitFlow 1](fig/42-movebranch.png)
![GitFlow 1](fig/41-cherrypick.png)

:::::::::::::::::::::::::::::::::::::::: keypoints

- Making changes to a repository is not permanent; you can undo commits using `git reset`.
- You can always rename branches using `git branch -m`.
- You can cherrypick specific commits from one branch to another using `git cherry-pick <commit-hash>`.

::::::::::::::::::::::::::::::::::::::::::::::::::
