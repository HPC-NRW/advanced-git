---
title: "Forking Workflow"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Use the forking workflow to contribute to a project.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What are the common workflows of the forking branching model?

::::::::::::::::::::::::::::::::::::::::::::::::::

Preparation: Make sure that the main is clean, everything is committed.

The forking workflow is popular among open source software projects and often used in conjunction with a branching model.

The main advantage is that you enable people external to your project to implementent and suggest changes to your project without the need to give them push access to your project.
In this workflow developers usually interact with multiple (at least two) repositories and remotes: the original code
repository and the forked repository.
It is important to understand that a fork represents a **complete copy** of a
remote repository.

In order to understand the forking workflow, let's first take a look at some special words and roles needed:

- **upstream** - Remote repository containing the "original copy"
- **origin** - Remote repository containing the forked copy
- **pull request (PR)** / **merge request (MR)** - Request to merge changes from fork to upstream (a request to add your suggestions to the "original copy")
- **maintainer** - Someone with write access to upstream who vets PRs/MRs
- **contributor** - Someone who contributes to upstream via PRs/MRs
- **release manager** - A maintainer who also oversees releases

In this workflow changes are suggested and integrated into the "upstream main" branch via a
pull/merge request from an "origin branch" (and not the "origin main").
The "origin main" branch is updated by pulling changes from the "upstream main"
as they become available.

This way the "upstream main" remains the true source for any suggested change
in the project, while allowing anyone to work on their own contributions independently.

::: callout
Pull requests / merge requests are a service of the hosting platform to ease
code reviews and managing changes. They only work **within the same hosting
service**, while you certainly have remotes on several hosting services
configured for a repository.
:::

![Forking Workflow](fig/forking_workflow.svg){alt="A diagram showing the forking workflow with upstream, origin, and local repositories."}


#### Example workflows

- [Example release workflow for the astropy Python package](https://docs.astropy.org/en/latest/development/maintainers/releasing.html)
- [Spacetelescope (STScI) style guide for release workflow](https://github.com/spacetelescope/style-guides/blob/master/guides/release-workflow.md)


## The main workflow

Once you discover a hosted Git project that you want to contribute to, you can
create a fork of this repository.

::: group-tab

### Github

![Screenshot of the button array in the top right corner of the Github interface with the fork button highlighted.](fig/github_fork_button.png)

### Gitlab

![Screenshot of the button array in the top right corner of the Gitlab interface with the fork button highlighted.](fig/gitlab_fork_button.png)

:::

After clicking *fork* you can choose in which group you want to fork in. Only groups where you have write access will be listed.
Depending on the branching model of the upstream repository, you may want to copy only the `main` branch (or rather the branch set as the `default` branch).
For most repositories a full copy will be the best choice, especially if the upstream repository uses a more complex branching model.

#### Cloning the forked copy

After the fork is complete, you clone the repository as you would with any other personal project repository.
Your copy will then use the remote name *origin*.

On you cloned working copy you should then create a branch for your proposed changes.

::: caution
You should avoid changing the `main` branch of your local repository, as this should only be your reference to the upstream `main` branch, which eventually be providing updates (i.e., new commits). If you change your local `main` branch, its history will diverge from the upstream's history of the `main` branch causing problems in the future.
:::


#### Make changes and push branch to your fork

After you cloned the forked repository, you interact with it just the way you would with a repository of your own. In fact, the forked copy now *is* your own, as you have full access control over the forked project.
Remember to **only work on branches**.

#### Create a pull request

After pushing

::: challenge

## Exercise 1: Full fork-to-pull-request example

Complete the main *forking workflow* once for your project.

1. Fork a repository named by the workshop instructors.
2. Clone the repository
3. Create a new branch for the changes
3. Add and commit a change
4. Push branch to *origin* as the tracking branch

:::: solution
1. Fork the repository
2. Follow the clone-change-push workflow
```bash
git clone <repository-url>
git checkout -b myfeature
# make changes
git add <changed-files>
git commit -m "Add feature X"
git push --set-upstream origin myfeature
```
3. Create a merge request to the **upstream** repository.
::::

:::


## Keeping up-to-date

You may either want to continue to contribute to the forked project, or the forked project has received updates before your changes could be merged.
Either way, you will want to incorporate the upstream changes into the corresponding branches both in the forked repository and

As you never modify the `main` branch, it remains straight forward to pull in any change from upstream.
First you switch to the main branch of your working copy, pull in changes directly from *upstream* `main`, and push them to your forked repository on *origin*.
```bash
git switch main
git pull upstream main
git push --set-upstream origin main
```

Updating your branch is a bit more intricate.
Here, we want our contributed changes to be the last on the branch, so we need to **rebase** the branch.
When we rebase the branch to the newest commits on `main`, the history of the *origin* `branch` and the *working copy* branch will have diverged and you will have to update the *origin* `branch` by force.

```bash
git switch mybranch
git pull --rebase upstream main
# resolve potential conflicts
git push --force origin mybranch
```

::: caution
Force-pushing to a remote branch will invalidate any other copies of that branch in other people's working copies.
This, it is usually a bad idea to force-push on branches actually worked on by others.
In that case, just merge the changes with `git pull upstream main` creating a merge commit.
:::

::: callout
The reason why some people prefer the *rebase* over the *merge* is that it keeps the history cleaner.The merge commits
It therefore remains a judgement call and will largely be influenced by the specific policies in place for the repositories of the projects you collaborate with.
:::

::: challenge

## Exercise 2: Keeping things up-to-date

Update the copies of your `main` branch after the successfull merge of the pull request.

:::: solution
After the merge request is complete, you need to update your `main` branches from *upstream*
```bash
git switch main
git pull upstream main
git push --set-upstream origin main
```
::::
:::

## Exercises

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise 1a: Create and push a feature branch

Create a fork of the demo repository provided by the instructor in your own GitLab account and
clone it locally. Follow the forking workflow to create a feature branch and suggest a change to
the original repository via a pull request.


:::::::::::::::  solution

1. Create a fork of the demo repository on GitLab under your own account.
2. Clone your forked repository locally with `git clone <your-forked-repo-url>`.
3. Create a new feature branch off `main` (`git branch <feature-branch-name>` and `git switch <feature-branch-name>`).
4. Make a change in the codebase (e.g., edit a file) and commit it (`git add .` and `git commit -m "Your commit message"`).
5. Push the feature branch to your forked repository (`git push -u origin <feature-branch-name>`).

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise 1b: Suggest your changes via pull request

Now that you have pushed your feature branch to your forked repository, create a pull request to
the original repository to suggest your changes.

:::::::::::::::  solution

1. Create a new merge request (pull request) on GitLab. The "Source Branch" should be your feature branch in your forked repository, and the "Target Branch" should be the `main` branch of the original repository.
2. Fill in the title and description for your pull request, explaining the changes you made.
3. Submit the pull request for review.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise 2: Update your forked repository

As other contributors make changes to the original repository, you need to keep your forked repository up to date.
Update your forked repository's `main` branch with the latest changes from the original repository's
`main` branch.

You can do this via the GitLab interface, but try to work with the git command line here.

::: hint

You will need to have the original repository added as a remote named `upstream` in your local clone of the forked repository.

:::

:::::::::::::::  solution

*via the command line*

1. Add the original repository as a remote named `upstream`:
   ```bash
   git remote add upstream <original-repo-url>
   ```
2. Fetch the latest changes from the original repository:
   ```bash
    git pull upstream main --rebase
    ```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::: keypoints

- The forking workflow allows third parties to prepare and propose changes
  without write access to the upstream repository
- The `main` branch is not modified but only be updated from the upstream
  `main` branch
- Branch off `main` to a feature branch, pushing to the forked repository
  (origin)
- Update forked `main` branch using `git pull upstream main` where `upstream`
  is the name of the upstream remote
- Update your local feature branch by `git pull --rebase upstream main`
- Force push to origin branch for pull request updates.

::::::::::::::::::::::::::::::::::::::::::::::::::
