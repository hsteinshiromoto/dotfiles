#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd ${PROJECT_ROOT}/homebrew && brew bundle dump
