#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd ${PROJECT_ROOT}/homebrew && rm Brewfile && brew bundle dump
