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

Reminder: when starting work on a new feature, be careful where you branch from!

```bash
git remote add upstream https://github.com/mpi-astronomy/advanced-git-training.git
git fetch upstream
git checkout -b develop upstream/develop
```

## Non-fast-forwad Merge

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

## Fast-forward Merge

If there are no conflicts with the main branch, a "fast-forward" merge can be executed with. This will NOT create a merge commit! Aborts merge if it cannot be done.
Ideal for updating a branch from remote.

```bash
git checkout main
git merge --ff-only <branch>
```

If using the fast-forward merge, it is impossible to see from the `git` history which of the commit objects together have implemented a feature. You would have to manually read all the log messages. Reverting a whole feature (i.e. a group of commits), is a true headache in the latter situation, whereas it is easily done if the --no-ff flag was used.

For a good illustration of fast-forward merge (and other concepts), see this thread: https://stackoverflow.com/questions/9069061/what-effect-does-the-no-ff-flag-have-for-git-merge

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
