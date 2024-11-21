---
title: Cheat Sheet
---

This cheat sheet summarizes important commands from the introduction lesson [Version Control with Git](https://swcarpentry.github.io/git-novice).
In some commands a parameter appears in angle brackets (e.g. `<file>`). This notation symbolizes that a concrete parameter must be used here (in the example a file name).

# Git commands

## Setup

| command                                            | description       |
|----------------------------------------------------|-------------------|
| `git config --global user.name "<username>"`       | set user name     |
| `git config --global user.email "<email-address>"` | set email address |                                                   |                   |

## First steps

| command                                    | description                                                                                                                             |
|--------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `git init <repo-name>`                     | creates a new repository called `<repo-name>`                                                                                           |
| `git clone <repository>`                  | clones an existing repository                                                                                                           |
| `git status`                               | shows status message about the state of the working directory and staging area                                                          |
| `git add <file>`                           | adds `<file>` to staging area                                                                                                           |
| `git add .`                                | adds all files to the staging area that where changed since last commit                                                                 |
| `git commit -m "<commit-message>"`         | creates a commit from the current (staged) project state with the message `<commit-message>`                                            |
| `git commit --amend -m "<commit-message>"` | replaces last commit using new commit message; additional files can be staged beforehand (`git add`)                                    |
| `git gui`                                  | starts the graphical client for staging and committing                                                                                  |
| `cat .gitignore`                           | shows files ignored by Git<br>each line can contain a file name or patterns like `*.log` which will ignore all files ending with `.log` |
| `git status --ignored`                     | shows ignored files                                                                                                                     |

## Version history

| command                     | description                                                                                       |
|-----------------------------|---------------------------------------------------------------------------------------------------|
| `git log`                   | commit history                                                                                    |
| `git log <file>`            | commit history for `<file>`                                                                       |
| `git log -<n>`              | commit history of the last `<n>` commits (e.g. `git log -3` for last three commits)               |
| `git log --oneline`         | commit history, single-line display                                                               |
| `git log --stat`            | commit history including which files have been changed and how many lines have been deleted/added |
| `git log --grep="<string>"` | commits whose commit message contains `<string>`                                                  |
| `gitk`                      | starts the graphical client for commit history                                                    |

## Changes

| command                                         | description                                                                                                                          |
|-------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `git diff`                                      | shows unstaged changes in the working directory                                                                                      |
| `git diff <commit>` <br> `git diff <commit> --` | shows differences between `<commit>` and current working directory                                                                   |
| `git diff <commit-A> <commit-B>`                | shows differences between `<commit-A>` and `<commit-B>` <br> example calls: `git diff HEAD~3 HEAD~1` <br> `git diff a372d2d 6ef3d23` |


## Previous versions

| command                                | description                                                                         |
|----------------------------------------|-------------------------------------------------------------------------------------|
| `git restore <file>`                   | restores unstaged changes in the working directory to the state of the last commit. |
| `git checkout -- <file>`               | same as `git restore <file>`                                                        |
| `git restore --staged <file>`          | removes a file from the staging area ("unstaging")                                  |
| `git restore --source <commit> <file>` | restores `<file>` to its state in `<commit>`                                        |

## Looking at earlier project states

| command                 | description                                                                                                                               |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `git checkout <commit>` | get earlier project state (`<commit>`) into working directory -> `DETACHED HEAD`, do not commit now!                                      |
| `git checkout <branch>` | if `DETACHED HEAD`: back to current commit, reattaches `HEAD`, committing is harmless again. `<branch>` is `main` or `master` by default. |

## Reset project

| command              | description                                                                                      |
|----------------------|--------------------------------------------------------------------------------------------------|
| `git reset <commit>` | set repository back into the state of `<commit>`, caution: deletes all commits after `<commit>`! |

## Working with remote repositories

| command                              | description                                             |
|--------------------------------------|---------------------------------------------------------|
| `git remote -v`                      | lists remotes                                           |
| `git remote add <name> <url>`        | adds remote `<name>` pointing at `<url>`                |
| `git remote set-url <name> <new-url>` | changes URL of remote `<name>` to `<new-url>`            |
| `git pull <name>`                    | incorporates changes from remote `<name>`               |
| `git push <name>`                    | pushes changes from current branch into remote `<name>` |

