#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

for file in ~/.config/kitty/*
do 
    echo copying ${file}
    cp ${file} ${PROJECT_ROOT}/kitty
done