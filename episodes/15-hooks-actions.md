---
title: "Hooks"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::::: questions

- How do I automate checks on my commit?
- How do I check changes before a commit?

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: objectives

- Learn about using hooks to improve quality of commits

::::::::::::::::::::::::::::::::::::::::::::::::::

Git hooks are scripts that get run when a specific event occurs in git. The scripts can be written in any language and do anything you like, so any executauble script can be a hook.

Git hooks can trigger events on the server size or locally. Examples of local events that can trigger hooks include `commit` (pre- or post-commit hooks), `checkout` or `rebase`. Pre-commit hooks are perhaps the most common and useful ones: they trigger actions before the code is committed and if the hook script fails, then the command is aborted. This can be very powerful - you can automatically run linters, before the code is even committed.

List of pre-written pre-commit hooks: https://github.com/pre-commit/pre-commit-hooks

The executable files are stored in the `.git/hooks/` directory in your project directory. A pre-commit hooks will be an executable file in this directory stored with the magic name `pre-commit`. Check the directory, there are already several examples. Let's create a new one

```bash
touch .git/hooks/pre-commit
nano .git/hooks/pre-commit
```

And add the following text to it:

~~~
#!/usr/bin/env bash

set -eo pipefail
flake8 hello.py
echo "flake8 passed!"
~~~

Now let's make `hello.py`:

```bash
touch hello.py
nano hello.py
```

And add some text to it:

```python
print('Hello world!'')
```

The typo is on purpose. Add and commit it to the repository.

GitHub actions are the equivalent of server-side hooks on GitHub.

There are lots of things that can be done with GitHub actions: https://docs.github.com/en/actions

Here is an example of a simple cron job: https://github.com/mpi-astronomy/XarXiv


![GitFlow 1](fig/47-hooks.png)

Materials: https://verdantfox.com/blog/how-to-use-git-pre-commit-hooks-the-hard-way-and-the-easy-way

:::::::::::::::::::::::::::::::::::::::: keypoints

- Git provides a list of different hooks for you to run tasks at specific times
  in the commit
- Use the `pre-commit` hook to check for change conformity before changes are
  committed

::::::::::::::::::::::::::::::::::::::::::::::::::

{% include links.md %}
