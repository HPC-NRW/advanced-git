---
title: "Setting up the Command Prompt"
teaching: 5
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Improve your command prompt for working with Git

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I visualize Git information at a glance in the command prompt?

::::::::::::::::::::::::::::::::::::::::::::::::::

When working with the command prompt in Git, it may prove helpful to keep
some information about the repository available at a glance. As Unix shells
allow to modify the prompt, a natural approach is to integrate such information
into the prompt itself.

:::::::::::::::::::::::::::::::::::::::  challenge

## What would be useful information to integrate into the prompt?

Take a minute to think about which information might be helpful to be shown as part of the prompt.

:::::::::::::::  solution

## Some ideas.

- **The active branch.** As you can switch between different branches of the same repository, it
  can sometimes be confusing to know which branch your working copy currently reflects. Presenting
  the branch name as part of the directory name you are currently in may help as a reminder.
- **The state of the branch.** An indicator on whether there are modified or uncommitted files in
  the repository may help in noticing uncommitted changes in the repository.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Setting up the query infrastructure

Individual shells have specific ways to define the prompt and the information shown. Select the
appropriate code snippet according to the shell you are running. If you are unsure which shell
you are using, try the following code to identify the shell you are running.

```bash
you@computer:~$ basename $SHELL
bash
```

As the idea to augment the command prompt with Git information is not new, the Git repository on
Github (i.e., the repository hosting the source code for Git itself) also provides the shell code
to query different information. You can download it to your home directory with the following commands.

```bash
you@computer:~$ curl https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh -o $HOME/.git-prompt.sh
```

::: callout

## bash

To use the `git-prompt.sh` in `bash` add the following line to `$HOME/.bashrc`.
```bash
source ~/.git-prompt.sh
```

:::

::: callout

## zsh

To use the `git-prompt.sh` in `zsh` add the following line to `$HOME/.zshrc`.
```bash
source ~/.git-prompt.sh
```
}
:::

Some shells, such as fish, xonsh, and others already have support for displaying Git repository information built-in.

Now you have the infrastructure set up to augment the command prompt with desired information about your Git repository.

## Modifying the prompts

With the code to query the information is already available in the shell session,  we still need to use the information in the definition of our prompt.

::: callout

## bash

Add the following to your `$HOME/.bashrc`.

```bash
PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
```

will show username, at-sign, host, colon, cwd, then
various status string, followed by dollar and SP, as
  your prompt.

:::

::: callout

## zsh

Add the following to your `$HOME/.bashrc`.

```bash
setopt PROMPT_SUBST
PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
```

This will show username, pipe, then various status string, followed by colon, cwd, dollar and SP, as your prompt.

:::

## Tweaking the information shown

Using the `git-prompt.sh` script you can now tweak the information shown in the prompt by setting specific environment variables.

### Indicating unstaged and uncommitted changes in the working copy

By setting the environment variable `GIT_PS1_SHOWDIRTYSTATE` to a non-empty value, the prompt will indicate modified files in the working copy with an `*` character.

```bash
user@computer:my_repo (main *)> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   a_file.py

no changes added to commit (use "git add" and/or "git commit -a")
user@computer:my_repo (main *)$
```

### Indicating untracked files in the working copy

By setting the environment variable `GIT_PS1_SHOWUNTRACKEDFILES` to a non-empty value, the prompt will indicate the presence of untracked files
in the working copy with a `%` character next to the branch name.

```bash
user@computer:my_repo (main %)> git status
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        untracked.pdf

no changes added to commit (use "git add" and/or "git commit -a")
user@computer:my_repo (main %)>
```

### Indicating a stash in the working copy

Git supports saving modifications to the working copy in a so-called stash that can later be reapplied to the working copy.
By setting the environment variable `GIT_PS1_SHOWSTASHSTATE` to a nonempty value, the prompt will indicate wheter something is stashed,
with a `$` next to the branch name.

```bash
you@computer:my_repo (main $)> git stash
Saved working directory and index state WIP on main: 33528c7 Added report
you@computer:my_repo (main $)> git stash clear
you@computer:my_repo (main)>
```

### Indicating the name of and difference to the upstream repository

The environment variable `GIT_PS1_SHOWUPSTREAM` can be set to a space-separated list of options to show relation of the local working copy to an upstream repository. For basic use, you can select between the following options.

- **verbose** show the number of commits behind (-) or ahead (+) if not equal (=) to upstream.
- **name** show the abbreviated name of the upstream repository
- **auto** chooses a sensible set of information depending on the status of the working copy.

```bash
you@itc19060:my_repo (main *)> echo $GIT_PS1_SHOWUPSTREAM

you@computer:my_repo (main *)> GIT_PS1_SHOWUPSTREAM="verbose"
you@computer:my_repo (main *|u+3)> GIT_PS1_SHOWUPSTREAM="verbose name"
you@computer:my_repo (main *|u+3 origin/main)> GIT_PS1_SHOWUPSTREAM="auto"
you@computer:my_repo (main *>)>
```

::: callout

There are more options for advanced usage available. Check inside of `git-prompt.sh` for documentation.

:::

### Colorizing the output

If the environment variable `GIT_PS1_SHOWCOLORHINTS` is set to any value, the Git-related part of the output in the prompt will be colorized.
If the variable is not set, the output will not be colourized.

:::::::::::::::::::::::::::::::::::::::: keypoints

- Use available scripts for common shell environments.
- Indicate changes stashed, pending, or committed to the local working copy.
- Indicate current branch name to aid in multi-branch workflows.

::::::::::::::::::::::::::::::::::::::::::::::::::
