#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)
for file in config 
do
    echo copying ${file}
    cp ~/.ssh/${file} ${PROJECT_ROOT}/ssh
done
