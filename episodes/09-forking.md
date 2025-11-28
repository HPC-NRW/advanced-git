---
title: "Forking Workflow"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- First learning objective. (FIXME)

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


## Exercises

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise 1: Create and push a feature branch

:::::::::::::::  solution

```bash
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise 2: Suggest your changes via pull request

:::::::::::::::  solution


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
