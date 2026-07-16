---
title: "Introduction"
teaching: 10
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understand the range of functionality that exists in git.
- Understand the different challenges that arise with collaborative projects.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What do I do when I need to make complex decisions with my git repository?
- How do I collaborate on a software project with others?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

Version control systems are a way to keep track of changes in text-based documents.
We start with a base version of the document and then record the changes you make each step of the way.
You can think of it as a recording of your progress: you can rewind to start at the base document and play back each change you made, eventually arriving at your more recent version.

The git version control system, used to manage the code in many millions of software projects, is one of the most widely adopted one.
It uses a distributed version control model (the "beautiful graph theory tree model"), meaning that there is no single central repository of code.
Instead, users share code back and forth to synchronize their repositories, and it is up to each project to define processes and procedures for managing the flow of changes into a stable software product.

## Challenges

Git is powerful and flexible to fit a wide range of use cases and workflows from simple projects written by a single contributor to projects that are millions of lines and have hundreds of co-authors.
Furthermore, it does a task that is quite complex. As a result, many users may find it challenging to navigate this complexity.
While committing and sharing changes is fairly straightforward, recovering from situations such as accidental commits, pushes or bad merges is difficult without a solid understanding of the rather large and complex conceptual model.
Case in point, three of the top five highest voted questions on Stack Overflow are questions about how to carry out relatively simple tasks: undoing the last commit, changing the last commit message, and deleting a remote branch.

[![XKCD Git](fig/01-xkcd-git.png){alt="An XKCD comic about the git control system."}](https://xkcd.com/1597/)

*Mouse-over text: If that doesn't fix it, git.txt contains the phone number of a friend of mine who understands git. Just wait through a few minutes of 'It's really pretty simple, just think of branches as...' and eventually you'll learn the commands that will fix everything.*

With this lesson our goal is to give a you a more in-depth understanding of the conceptual model of git, to guide you through increasingly complex workflows and to give you the confidence to participate in larger projects.

## Quick Review

Let's take a moment to review some of the basic git commands.

### Initializing a Repository

```bash
git init
```
git init creates a new git repository in the current directory.
Specifically, this means creating a subdirectory named `.git` that contains your repository's metadata and object database.
Generally speaking, we don't tinker with this directory, but it's useful to know that it exists and that is is the marker of a folder on our computer being a git repository.

### The Git Workflow

git has a three-stage workflow: the working directory, the staging area, and the repository.
When we make changes to files in our working directory, they are not included in the next commit until we stage them, which is done by adding them to the staging area.
The staging area allows us to prepare a snapshot of the changes before committing them to the repository.
Once we are satisfied with the changes in the staging area, we can commit them to the repository, which records the changes and creates a new commit object.

![Staging Area](fig/02-staging-area.png){alt="A diagram showing the relationship between the working directory, staging area, and repository in git."}

```bash
git add file.txt
git commit -m "Message"
```

A commit, or "revision", is an individual change to a file or set of files.
It's like when you save a file, except with `git`, every time you save it creates a unique ID (a.k.a. the "SHA" or "hash") that allows you to keep record of what changes were made when and by who.
Each commit contains several key pieces of information that uniquely define its state:

- **Commit message**: A description provided by the user explaining the purpose or details of the commit.

- **Committer**: The person who added the commit to the repository.

- **Commit date**: The date and time when the commit was added to the repository.

- **Author**: The original creator of the changes in the commit, which may differ from the committer.

- **Authoring date**: The date and time when the changes were originally made by the author.

- **Parent commit(s)**: Reference to the previous commit(s), which allows Git to trace the history and create a chain of commits.

- **Working directory hash**: A unique hash representing the state of all tracked files in the working directory at the time of the commit.

![What is in a Commit](fig/04-recap.png){alt="A diagram showing the components that make up a git commit."}

All these elements together generate a unique **commit hash**, which identifies the commit across the Git repository.

### Interacting with Remote Repositories

To collaborate with others, we often work with remote repositories.

- `git clone http://....`: Creates a local copy of a remote repository, allowing you to work on it locally.
- `git push`: Uploads your local commits to a remote repository, sharing your changes with others.
- `git pull`: Fetches and integrates changes from a remote repository into your local branch, keeping your local copy up to date.
- `git fetch`: Downloads commits, files, and refs from a remote repository into your local repository without merging them into your current branch.

::: callout

You can consider git fetch the 'safe' version of the two commands.
It will download the remote content but not update your local repository's working state, leaving your current work intact.
`git pull` is the more aggressive alternative; it will download the remote content for the active local branch and immediately execute `git merge` to create a merge commit for the new remote content.
If you have pending changes in progress this will cause conflicts and kick-off the merge conflict resolution flow.

:::

It is sometimes useful to only pull the changes from a certain branch, e.g., `main`.
For a repository that has a lot of contributors and branches, all the changes may be unnecessary and overwhelming:

```bash
git fetch origin main
```

In the event you haven't already, let's clone the repository for this lesson now.

```bash
git clone {REPOSITORY_URL}
```

### Exploring the Repository

Let's take a moment to explore the repository we just cloned.
We can use the `git log` command to view the commit history of the repository up to this point in time:

```bash
$ git log
commit 90eaaeca5915397e1247d3a041120ee97649ae23 (HEAD -> main, git-adv-01-introduction)
Author: Demo User <demo@email.com>
Date:   Wed Jul 15 17:03:58 2026 +0200

    Merge changes from remote repository

commit 76f0214a989c3da6c7d2bb37f4967bc065d480b6 (git-basic-09-conflict)
Author: Demo User <demo@email.com>
Date:   Wed Jul 15 17:03:58 2026 +0200

    Add ingredients for hummus

commit 72bad66f6ceb4e09f045df63caa88d80e0b833ca (git-basic-08-collab, git-basic-07-remotes)
Author: Demo User <demo@email.com>
Date:   Wed Jul 15 17:03:57 2026 +0200

    Ignore png files and the pictures folder.
:
```

It is likely that the commits from this repository will not fit on your screen.
If this is the case, you will see a `:` character at the bottom of the screen, indicating that you are in "pager" mode.
You can use the arrow keys to scroll up and down through the commit history, or press `q` to exit pager mode and return to the command prompt.

Like the `git commit` command, we can add additional "flags" to the command to customize the output.
Try the following to get a more compact view of the commit history:

```bash
git log --oneline
git log -n 3
```

### Comparing Files between Commits

One of the most useful features of git is the ability to quickly view or compare changes made to files between commits.
We can use the `git diff` command to see differences between the most recent commit and an earlier commit by providing the commit hash of the earlier commit.

```bash
$ git diff 72bad66

diff --git a/guacamole.md b/guacamole.md
index 76a6108..18682f5 100644
--- a/guacamole.md
+++ b/guacamole.md
@@ -4,3 +4,4 @@
 * lime (0.64)
 * salt (2)
 ## Instructions
+* peel the avocados and put them into a bowl.
diff --git a/hummus.md b/hummus.md
new file mode 100644
index 0000000..3c51b6b
--- /dev/null
+++ b/hummus.md
@@ -0,0 +1,6 @@
+# Hummus
+## Ingredients
+* chickpeas
+* lemon
+* olive oil
+* salt
```

We can also use relative commit references to compare files between commits, instead of using the full commit hash.

```bash
git diff HEAD~2
```

https://www.atlassian.com/git/tutorials/syncing/git-fetch

![Review 2](fig/03-recap.png){alt="A diagram showing alternate diagrams for understanding the working directory, staging area, and repository in git, as well as commits on a branch."}

:::::::::::::::::::::::::::::::::::::::: keypoints

- Git version control records text-based differences between files.
- Each git commit records a change relative to the previous state of the documents.
- Git has a range of functionality that allows users to manage the changes they make.
- This complex functionality is especially useful when collaborating on projects with others

::::::::::::::::::::::::::::::::::::::::::::::::::
