# pylinter

[![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python)

Enforce python linting on commits and pull requests.

## Linting Packages Used

* [`flake8`](https://pypi.org/project/flake8/)

* [`mypy`](https://pypi.org/project/mypy/)

* [`isort`](https://pypi.org/project/isort/)

## Optional Inputs
* `python-root`
	* directory to run linters on

	* by default `mypy` does not run recursively, but will here

* `flake8-flags`
	* flags to run with `flake8` command

* `mypy-flags`
	* flags to run with `flake8` command

* `fail-on-isort`
	* whether to fail job if `isort` changes needed

	* if set to `false`, isort will run and modify necessary files (auto-commit, shown below, can then be run to push changes)

## Outputs
Print associated errors with failed job. The order of linters are `flake8`, `mypy`, `isort`. If any linter fails, the job will fail and no subsequent linters will run.

## Quick Start
### Default (no flags)
```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@v2

    - name: linting
      uses: alexanderdamiani/pylinter@v1.0.0
```

### Optional flags
```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@v2

    - name: linting
      uses: alexanderdamiani/pylinter@v1.0.0
      with:
        python-root: '.'
        flake8-flags: '--count --show-source --statistics'
        mypy-flags: '--ignore-missing-imports'
        fail-on-isort: true
```
### Auto-commit/push `isort` changes
```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@v2

    - name: linting
      uses: alexanderdamiani/pylinter@v1.0.0
      with:
        python-root: '.'
        flake8-flags: '--count --show-source --statistics'
        mypy-flags: '--ignore-missing-imports'
        fail-on-isort: true

    - name: commit isort changes
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add -A && git diff-index --cached --quiet HEAD || git commit -m 'isort'

    - name: push isort changes
      uses: ad-m/github-push-action@v0.5.0
      with:
        github_token: ${{ secrets.GH_ACCESS_TOKEN }}
        branch: ${{ github.ref }}
```

## ENV Vars
* `GH_ACCESS_TOKEN`

	* https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

	* Necessary to auto-commit/push `isort` changes

## License
[MIT License](https://github.com/git/git-scm.com/blob/master/MIT-LICENSE.txt)
