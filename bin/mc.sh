#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)
for file in ini mc.ext mc.ext.ini panels.ini hotlist
do
    echo copying ${file}
    cp ~/.config/mc/${file} ${PROJECT_ROOT}/mc
done