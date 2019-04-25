# workflow-standards

This repository contains information and supporting scripts to maintain consistent, standardized CWL workflows in git repositories for running in [bespin](https://github.com/Duke-GCB/bespin)

## Workflow and Repository Structure

Each repository shall represent a workflow or family of closely related workflows that share common core software versions and/or targets. One workflow in a repository may be a subset of another, or may have different steps. Major differences that constitute a completely different workflow or set of software versions must be a different repository.

Example contents:

```
.circleci/
.gitignore
CHANGELOG.md
LICENSE
README.md
examples/
exomeseq-gatk4-preprocessing.cwl
exomeseq-gatk4.cwl
requirements.txt
subworkflows/
tools/
types/
utils/
```

Here, the two workflows are `exomeseq-gatk4.cwl` and `exomeseq-gatk4-preprocessing.cwl`


## Development and Release process

Each repository shall have a `develop` branch, and one or more `release-X.Y` branches.

Changes shall be proposed to the `develop` branch through pull request using the following process:

1. Create a feature branch from `develop`
2. Author changes, and describe them in the `CHANGELOG.md` unreleased section.
3. Submit the pull request to merge into `develop`

Once changes are accepted and merged into `develop`, they may be merged into a release branch:

1. Decide on a new version number, following [Semantic Versioning](http://semver.org)
2. Merge your changes from `develop` into (or create new) the `release-X.Y` branch corresponding to the new  version.
3. Edit the `.cwl` files in the repo root to indicate the new version in the `doc` and `label` fields. See _Versioning and Metadata__ below.
4. Create a section in `CHANGELOG.md` for the release, moving items out of the unreleased section
5. Validate the local repo for the chosen version using the `validate.sh` script: `validate.sh /path/to/workflow-repo vX.Y.Z`

6. Upon successful validation, commit the changes and push them to the `release-X.Y` remote branch

A GitHub release for the new version should be created from the `release-X.Y` branch:

1. Visit https://github.com/bespin-workflows/workflow-name/releases/new
2. Enter a version in the format `vX.Y.Z`, targeting `release-X.Y`
3. Title the release `vX.Y.Z`
4. Paste the version's entry from `CHANGELOG.md` as the description
5. Publish the release.

## Versioning and Metadata

The CWL workflow's `label` field should consist of the workflow's bespin tag and version string, separated by a `/`.

The CWL workflow's `doc` field should be a short description containing the version string.

Example:

*For version v2.0.0 of workflow `exomeseq-gatk4.cwl`:*

```
label: exomeseq-gatk4/v2.0.0
doc: Whole Exome Sequence analysis using GATK4 - v2.0.0`
```

## Scripts

The `validate.sh` script in this repository will validate your repository (and CWL workflows) for these standards. It also checks that other essential files in the git repo are present (e.g. README.md, CHANGELOG.md) and that files have required contents (e.g. CI configs, requriements.txt).

The `validate.sh` script uses [bespin-cli](https://github.com/duke-gcb/bespin-cli) to validate workflows.


