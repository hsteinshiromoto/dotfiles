#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)
for file in .tmux.conf 
do
    echo copying ${file}
    cp ~/${file} ${PROJECT_ROOT}/tmux
done
