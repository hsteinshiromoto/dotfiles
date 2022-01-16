#!/usr/bin/env bash

# This file automatically updates the versions of files setup.py and __init__.py
# based on the latest git tag and the release branch name

# Copy this file to .git/hooks/

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
BRANCH_TYPE=$(echo ${BRANCH_NAME}| cut -d/ -f1)
NEXT_VERSION=$(echo ${BRANCH_NAME} | cut -d "v" -f2- | cut -d "v" -f2-)
PREVIOUS_VERSION=$(git tag -l --sort=-creatordate | head -n 1 | cut -d "v" -f2-)
PROJECT_NAME=$(basename $(git remote get-url origin) .git)
PROJECT_ROOT=$(git rev-parse --show-toplevel)
CURRENT_RELEASE_DATE=$(date +%F)
PREVIOUS_RELEASE_DATE=$(git log --tags --simplify-by-decoration --pretty="format:%ai %d" | head -n 1 | cut -d " " -f1)

if [ "$BRANCH_TYPE" == "release" ]; then
	echo "Running post-checkout git hook on branch $BRANCH_NAME"

	echo "Updating version $PREVIOUS_VERSION to $NEXT_VERSION"
	sed -i -e "s/$PREVIOUS_VERSION/$NEXT_VERSION/g" ${PROJECT_ROOT}/setup.py
	sed -i -e "s/$PREVIOUS_VERSION/$NEXT_VERSION/g" ${PROJECT_ROOT}/CITATION.cff
	sed -i -e "s/$PREVIOUS_VERSION/$NEXT_VERSION/g" ${PROJECT_ROOT}/conf.py
	sed -i -e "s/$PREVIOUS_VERSION/$NEXT_VERSION/g" ${PROJECT_ROOT}/${PROJECT_NAME}/__init__.py

	echo "Updating release date $PREVIOUS_RELEASE_DATE to $CURRENT_RELEASE_DATE"
	sed -i -e "s/$PREVIOUS_RELEASE_DATE/$CURRENT_RELEASE_DATE/g" ${PROJECT_ROOT}/CITATION.cff

fi
