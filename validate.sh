#!/bin/bash

# Validate a bespin-workflows repo and contained workflows

set -e

REPO="$1"
VERSION="$2"
ERRORS=""

display_usage() {
	echo "This script is used to validate a local git repo for compliance to bespin-workflows standards."
	echo "It checks for files that should be in the repo and runs bespin-cli workflow-version validate on each cwl file the repo root"
	echo -e "\nUsage:\n$0 <repo path> <version string> \n"
	}

# if less than two arguments supplied, display usage
if [  $# -le 1 ]
then
  display_usage
  exit 1
fi

# Check for changelog

if [ ! -f "${REPO}/CHANGELOG.md" ]; then
  echo "CHANGELOG.md not found!"
  ERRORS=1
fi

# Check for README

if [ ! -f "${REPO}/README.md" ]; then
  echo "README.md not found!"
  ERRORS=1
fi

if [ -e "${REPO}/.gitmodules" ]; then
  echo "gitmodules should be gone"
  ERRORS=1
fi

REQUIREMENTS=$(cat "${REPO}/requirements.txt")

# Check for requirements.txt
if [ "$REQUIREMENTS" != "cwltool==1.0.20181217162649" ]; then
  echo "requirements.txt should just be one line"
  ERRORS=1
fi

IGNORE=$(cat "${REPO}/.gitignore")

# Check for .gitignore
if [ "$IGNORE" != "venv" ]; then
  echo "gitignore  should just be one line"
  ERRORS=1
fi

CIRCLECI_CHECKSUM=$(md5 -q "${REPO}/.circleci/config.yml" )
# Check for .gitignore
if [ "$CIRCLECI_CHECKSUM" != "a3fc50d6b91ad53b38b24ccdf14f5a1f" ]; then
  echo "Update the circleci config"
  ERRORS=1
fi

if [ "$ERRORS" != "" ]; then
  echo "Failed"
  exit 1
fi

set -e

# Check if .cwl files exist in repo
ls ${REPO}/*.cwl > /dev/null

# Validate the workflows
for workflow in ${REPO}/*.cwl; do
  WORKFLOW_TAG=$(basename -s .cwl $workflow)
  echo "Attempting to validate $workflow as ${WORKFLOW_TAG}/${VERSION}"
  bespin workflow-version validate --type direct --url "file://${workflow}" --path "" --version "${VERSION}" --workflow-tag "${WORKFLOW_TAG}"
done

echo "Succeeded"
