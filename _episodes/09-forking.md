---
title: "Forking Workflow"
teaching: 0
exercises: 0
questions:
- "What are the common workflows of the forking branching model?"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

Preparation: Make sure that the main is clean, everything is committed.

The forking workflow is popular among open source software projects and often used in conjunction with a branching model. 

FIXME: Why?

The focus of this workflow is to keep the "upstream main" stable while allowing anyone to work on their own contributions independently. Contributions are then suggested and accepted via pull requests. There is not necessarily a develop branch, but you may have release branches.

![GitFlow 1](../fig/27-forking-1.png)

In order to understand the forking workflow, let's first take a look at some special words and roles needed: 

*upstream* - Remote repository containing the "true copy"
*origin* - Remote repository containing the forked copy
Pull request(PR) - Merge request from fork to upstream (a request to add your suggestions to the "original copy")
Maintainer - Someone with write access to upstream who vets PRs
Contributor - Someone who contributes to upstream via PRs
Release manager - A maintainer who also oversees releases

[Example release workflow for the astropy Python package](https://docs.astropy.org/en/latest/development/maintainers/releasing.html)
[Spacetelescope (STScI) style guide for release workflow](https://github.com/spacetelescope/style-guides/blob/master/guides/release-workflow.md)


![GitFlow 1](../fig/29-forking-3.png){Alt: A brief refresher from Git Training: The figure shows the local computer ("You") with branch1 that includes three files of which one is indicated as removed. An arrow from the local computer points to the cloud in which origin and upstream are located, with a picture of GitHubs Octocat. The arrow from local points to origin with you/code(branch1), also with three files of which the same is indicated as removed. Origin has an arrow pointing to upstream with "PR" written on top of it and a screenshot of the "merge pull request" button from the GitHub webinterface. Upstream has spacetelescope/code (main) with the same three files of which the same file is indicated as removed as in local and origin.}

FIXME: Remove text from image and add as caption, source?

![GitFlow 1](../fig/30-forking-4.png){Alt: ...}

FIXME: Alt text. Remove text from image and add as caption, source?

## Exercises

FIXME: More description about what is happening at each step in the solution

### Exercise 1: Create and push a feature branch
> You will be assigned a number by the instructor/helper. 
> Create a feature branch based on upstream main. Then create a file in the `trainees` folder called `hello_NNN.txt` using the number you just got (replace NNN with your number, e.g. 007).
> Then push your featurebranch out to GitHub.
>
> > ## Solution
> > ~~~
> > git fetch upstream main
> > git checkout -b myforkfeature upstream/main
> > touch ./triainees/hello_NNN.txt
> > git add ./triainees/hello_NNN.txt
> > git commit -m "adding my textfile"
> > git push origin myforkfeature
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}

### Exercise 2: Suggest your changes via pull request

> Go to your repository (your fork) on GitHub and find the tab called "Pull requests". Klick the green "new pull request" button. Then find and click the blue link uder "Compare changes" called "compare across fork". Select your username and branch name from the right menus. Then click the big green button under the menus called "create pull request".

> > ## Solution
> > ![GitFlow 1](../fig/32-forking-6.png)
> {: .solution}
{: .challenge}

{% include links.md %}
