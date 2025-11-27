---
title: "Merging"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Learn about `git merge`.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I merge a branch changes?

::::::::::::::::::::::::::::::::::::::::::::::::::

When you are collaborating, you will have to merge a branch independent if your branch may or may not have diverged from the main branch. Most of the Git hosting platform like GiHub or GitLab allows you to merge a branch from their web interface but you can also merge the branches from your machine using `git merge`.

There are 2 ways to merge:

- non-fast-forward merged (recommended)

- fast forward merged

![Merging diagram.](fig/09-merging.png){alt="A diagram showing different types of Git merges."}


## Fast-forward Merge

If there are no conflicts with the main branch, we can perform a "fast-forward" merge. This works
by moving the branch pointer to the latest commit in the target branch. This is the default behavior
of `git merge` (when possible).

Let's mergin in our `yaml-format` branch back into `main` using a fast-forward merge:

```bash
git checkout main
git merge yaml-format
```

```output
$ git merge yaml-format
Updating ec240ab..68b09d0
Fast-forward
 guacamole.md   | 7 -------
 guacamole.yaml | 6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)
 delete mode 100644 guacamole.md
 create mode 100644 guacamole.yaml
```

If we look at the log, we can see that the commits that we made on the `yaml-format` branch are now
a part of the `main` branch:

```output
$ git log --oneline
68b09d0 (HEAD -> main, yaml-format) Rename recipe file to use .yaml extension.
a2b55be Reformat recipe to use YAML.
ec240ab Ignore png files and the pictures folder.
20c856c Write prices for ingredients and their source
11cdb65 Add some initial cakes
7cdeaef Modify guacamole to the traditional recipe
4b58094 Add ingredients for basic guacamole
cdb0c21 Create initial structure for a Guacamole recipe
```

If using the fast-forward merge, it is impossible to see from the `git` history which of the commit objects together have implemented a feature. You would have to manually read all the log messages. Reverting a whole feature (i.e. a group of commits), is a true headache in the latter situation, whereas it is easily done if the --no-ff flag was used.

For a good illustration of fast-forward merge (and other concepts), see this thread: https://stackoverflow.com/questions/9069061/what-effect-does-the-no-ff-flag-have-for-git-merge

## Non-fast-forwad Merge

A non fast-forward merge makes a new commit that ties together the histories of both branches.


Merges branch by creating a merge commit. Prompts for merge commit message. Ideal for merging two branches.

```bash
git checkout main
git merge --no-ff <branch> -m "Message"
```

The `--no-ff` flag causes the merge to always create a new commit object, even if the merge could be performed with a fast-forward. This avoids losing information about the historical existence of a feature branch and groups together all commits that together added the feature.

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise: Creating a non-fast-forwad merge.

Create a new Git repository that has the following tree.

```
*   69fac81 (main) Merge branch 'gitignore'
|\
| * 5537012 (gitignore) Add .gitignore
|/
* 6ec7c0f Add README
```
:::::::::::::::  solution


```bash
git init
touch README.md
git add README.md
git commit -m 'Add README'
git checkout -b gitignore
touch .gitignore
git add .gitignore
git commit -m "Add .gitignore"
git checkout main
git merge --no-ff gitignore
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise: Creating a fast-forwad merge.

Consider the following Git tree

```bash
* a78b99f (main) Add title
| * 3d88062 (remote) Add .gitignore
|/
* 86c4247 Add README
```

Is possible to run a fast-forward merge to incorporate the branch `remote` into `main`?

:::::::::::::::  solution

No, it is not possible to run a fast-forward merge because of commit `a78b99f`.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Three-way Merge

Similar to `--no-ff`, but there may be dragons. Forced upon you when there's an intermediate change since you branched.
May prompt your to manually resolve

```bash
git merge <branch> [-s <strategy>]
```

See https://git-scm.com/docs/merge-strategies for a zillion options (“patience”, “octopus”, etc),  But also git is only so smart and you are probably smarter.


Merging strategies: https://git-scm.com/docs/merge-strategies

[comment]: <> (![Merging 1](../fig/09-merging-1.png))
[comment]: <> (![Merging 2](../fig/10-merging-2.png)
[comment]: <> (![Merging FF](../fig/11-merging-ff.png))
[comment]: <> (![Merging no FF](../fig/12-merging-noff.png))
[comment]: <> (![Merging 3 Way](../fig/13-merging-3way.png))

https://nvie.com/posts/a-successful-git-branching-model/

Note: there are a number of external tools that have a graphical interface to allow for merge conflict resolution. Some of these include: kdiff3 (Windows, Mac, Linux), Meld (Windows, Linux), P4Merge (Windows, Mac, Linux),  opendiff (Mac), vimdiff (for Vim users), Beyond Compare, GitHub web interface. We do not endorse any of them and use at your own risk. In any case, using a graphical interface does not substitute for understanding what is happening under the hood.

:::::::::::::::::::::::::::::::::::::::: keypoints

- `git merge --no-ff` is the best way to merge changes
- `git merge --ff-only` is a good way to pull down changes from remote

::::::::::::::::::::::::::::::::::::::::::::::::::
