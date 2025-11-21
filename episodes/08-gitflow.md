---
title: "GitFlow"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- First learning objective. (FIXME)

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What are the common workflows of the GitFlow branching model?

::::::::::::::::::::::::::::::::::::::::::::::::::

Considered to be a bit complicated and advanced for many of today’s projects, `GitFlow` enables parallel development where developers can work separately from the master branch on features where a feature branch is created from the master branch.

Afterwards, when changes are complete, the developer merges these changes back to the master branch for release.

This branching strategy consists of the following branches:

- Master
- Develop
- Feature- to develop new features that branches off the develop branch
- Release- help prepare a new production release; usually branched from the develop branch and must be merged back to both develop and master
- Hotfix- also helps prepare for a release but unlike release branches, hotfix branches arise from a bug that has been discovered and must be resolved; it enables developers to keep working on their own changes on the develop branch while the bug is being fixed.

The main and develop branches are considered to be the main branches, with an infinite lifetime, while the rest are supporting branches that are meant to aid parallel development among developers, usually short-lived.

## GitFlow pros and cons

Perhaps the most obvious benefit of this model is that it allows for parallel development to protect the production code so the main branch remains stable for release while developers work on separate branches.

Moreover, the various types of branches make it easier for developers to organize their work. This strategy contains separate and straightforward branches for specific purposes though for that reason it may become complicated for many use cases.

It is also ideal when handling multiple versions of the production code.

However, as more branches are added, they may become difficult to manage as developers merge their changes from the development branch to the main. Developers will first need to create the release branch then make sure any final work is also merged back into the development branch and then that release branch will need to be merged into the main branch.

In the event that changes are tested and the test fails, it would become increasingly difficult to figure out where the issue is exactly as developers are lost in a sea of commits.

Indeed, due to GitFlow’s complexity, it could slow down the development process and release cycle. In that sense, GitFlow is not an efficient approach for teams wanting to implement continuous integration and continuous delivery.


![GitFlow 1](fig/17-gitflow-1.png)
![GitFlow 1](fig/18-gitflow-2.png)

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 1: Creating a Feature Branch

- 1. Go into the repository directory and check the repository status. Make sure the status is clean and, if not, commit any changes.
- 2. Check out a new feature branch off the development branch.
- 3. Create a new file that will contain your feature, edit it and commit it

:::::::::::::::  solution

Step 1:
```bash
cd advanced-git-training
git status
```

Step 2:
```bash
git fetch upstream
git checkout -b myfeature upstream/develop
```

Step 3:
```bash
touch coolstuff.txt
git add coolstuff.txt
git commit -m "Add cool stuff."
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

Now you have a feature branch.

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 2: Making Changes on the `develop` Branch

Now, while you were developing your feature, someone else merged their changes, `otherstuff.txt` in the develop branch. Let's make those changes here by hand so we can then practice merging our `coolfeature` into the `develop` branch.

1. Checkout the `develop` branch:
2. Create a new file named, for example, `otherstuff.txt`, edit it, add it and commit it to the develop branch.

:::::::::::::::  solution

Step 1:
```bash
git checkout develop
```

Step 2:
```bash
touch otherstuff.txt
git add otherstuff.txt
git commit -m "Stuff from another feature."
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 3: Finish Feature

Merge the `myfeature` branch into `develop`. Make sure you are still on the `develop` branch by checking the status `git status`.

1. Create a merge commit from the `myfeature` branch
2. Delete the feature branch
3. Check the history again with `git log` and check the directory content with `ls`. Is your feature file here?

:::::::::::::::  solution

Step 1:
```bash
git merge --no-ff myfeature
```

Step 2:
```bash
git branch -d myfeature
```

Step 3:
```bash
git log
ls
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

<!--- ![GitFlow 1](../fig/19-gitflow-3.png) --->
<!--- ![GitFlow 1](../fig/20-gitflow-4.png) --->
<!--- ![GitFlow 1](../fig/21-gitflow-5.png) --->


## Gitflow Release Branching





![GitFlow 1](fig/22-gitflow-6.png)

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 4: Gitflow Release

1. Create a release branch. Release branches should start from the `develop` branch.
2. Switch to the `main` branch. We will merge the release branch into `main`. Create a merge commit on `main` from `release-1.0`:
3. Tag the release, push the tag out and delete the release branch:

:::::::::::::::  solution

Step 1:
```bash
git checkout -b release-1.0 develop
```

Step 2:
```bash
git checkout main
git merge --no-ff release-1.0
```

Step 3:
```bash
git tag -a 1.0 -m "Version 1.0"
git push origin 1.0
git branch -d release-1.0
```

You can now check the Releases tab on GitHub to see your tagged release.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

<!---  ![GitFlow 1](../fig/23-gitflow-7.png) --->

## Gitflow Hotfix

![GitFlow 1](fig/24-gitflow-8.png)

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 5: Gitflow Hotfix

Imagine we made a release but we realized that there is a bug in our cool feature in `coolstuff.txt`. How do we fix that? We make a hotfix on the code which we then merge into both `main` and `develop` and we tag a new hotfix release.

1. First, create a hotfix branch off main, this is where our released code lives, we need to fix it.
2. Now, make some changes to `coolstuff.txt`, add and commit it.
3. Switch back to the main branch and merge the commit.
4. Tag a new release and push it to GitHub.
5. We also need to merge our change to `develop` so that it is propagated into the code that is the same as the released version.
6. Finally we can delete the hotfix branch.

:::::::::::::::  solution

Step 1:
```bash
git checkout -b hotfix-1.0.1 main
```

Step 2:
```bash
echo "Hotfix line" >> coolstuff.txt
git add coolstuff.txt
git commit -m "Cool hotfix"
```

Step 3:
```bash
git checkout main
git merge --no-ff hotfix-1.0.1
```

Step 4:
```bash
git tag -a 1.0.1 -m "Version 1.0.1"
git push origin 1.0.1
```

Step 5:
```bash
git checkout develop
git merge --no-ff hotfix-1.0.1
```

Step 6:
```bash
git branch -d hotfix-1.0.1
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


<!--- ![GitFlow 1](../fig/25-gitflow-9.png) --->

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 6: Gitflow Wrap-up

To wrap up the Gitflow workflow we want to make sure we have pushed all our `develop` and `main` changes to the remote repository.
<!--- ![GitFlow 1](../fig/26-gitflow-10.png) --->
![GitFlow 1](fig/in_case_of_fire.png)

1. First, as always, check the status of your repository and make sure you are still on the `develop` branch.
2. Then push any changes from develop to the remote.
3. And do the same with the `main` branch.

:::::::::::::::  solution

Step 1:
```bash
git status
git branch
git tag
```

Step 2:
```bash
git push origin develop
```

Step 3:
```bash
git checkout main
git push origin main
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

https://www.flagship.io/git-branching-strategies/

:::::::::::::::::::::::::::::::::::::::: keypoints

- First key point. Brief Answer to questions. (FIXME)

::::::::::::::::::::::::::::::::::::::::::::::::::
