---
title: "Interactive Rebase and Squash"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::::: questions

- Why would I rebase a branch?
- When would I squash commits during a rebase?

::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::: objectives

- Understand the reasons for interactive rebases.
- Remove ammending commits from the history.

::::::::::::::::::::::::::::::::::::::::::::::::::

The process of getting a pull request or merge request accepted and merged into
the upstream repository can require several updates to the original proposed
changes.
These changes may be functional fixes or just changes due to coding policies
required for the project.
This often results in multiple changes concerning the same peace of the code or
document to be both spacially and temporaly apart from each other in the Git
history.
For some projects a cluttered history is not acceptable and you may need to
clean up the history.

Git provides a command to modify the history of a branch called an *interactive
rebase*.

Let's first look at the history of our branch

```bash
git switch myfeature
git log --oneline myfeature..main
```
```output
# some output that shows multiple candidates for reordering and squashing
```

For cleaning up the history we focus on the first 4 commit of the branch.

```bash
git rebase -i HEAD~4
```

Git will open an editor with a list of the requested commits in the format
```output
pick 086ba4c Add Apple Pie recipe
pick 28a6dc9 Add recipe for Pecan Pie with ingredience
pick 4dd50a5 Add Pecan Pie instruction
pick 8337562 Fix typo in ingredients
```

Git provides different options for `<cmd>` to modify the specific
commit. Below you find a selection of commands that are most often used in
basic interactive rebasing.

- **pick**: Use this commit
- **reword**: Use this commit, but adapt the commit message
- **edit**: Use commit, but pause to shell before committing
- **squash**: Use commit, but as part of the previous commit combining commit
  messages
- **fixup**: Like squash, but keep only a single commit message
- **drop**: Remove commit

Initially all commits are listed with **pick**, as this would recreate the same
state as before the interactive rebase was started.
You are now free to change the order of those commits as long as dependencies
are retained.

In our example before, we could reorder and squash to keep two commits
regarding Pecan Pie.

```output
pick 086ba4c Add Apple Pie recipe
pick 28a6dc9 Add recipe for Pecan Pie with ingredience
fixup 8337562 Fix typo in ingredients
pick 4dd50a5 Add Pecan Pie instruction
```

Now save this list and let Git apply the desired changes.
After the rebase is complete, you can look at the rewritten history.

```bash
git log --oneline myfeature..main
```
```output
```

As we have changed the history, the branch at *origin* has diverged from the
local branch.
This will be noted in the current status of repository.

```
git status
```
```output
```

As this is the last step before final check and merge, it should be safe to
force-push the changes to *origin*.

```bash
git push --force origin
```
```output
```

::: challenge

## Exercise 1: Cleaning up history in a feature branch

Clean up the history of your feature branch before the pull request/merge
request is merged.

:::: solution
tbd.
::::
:::

![GitFlow 1](fig/44-rebase.png)
![GitFlow 1](fig/45-squash.png)
![GitFlow 1](fig/46-bisect.png)
![GitFlow 1](fig/48-patches.png)

:::::::::::::::::::::::::::::::::::::::: keypoints

- Use an interactive rebase to clean up merge requests before the merge.
- Rebased branches need to be force-pushed due to history changes.
- Squashing can be used to combine multiple commits
- Depending on the project policy merge requests may need to be cleaned up
  before they are allowed upstream.

::::::::::::::::::::::::::::::::::::::::::::::::::

{% include links.md %}
