#!/usr/bin/env bash

python_version=${python_version:-3.9}

get_images(){
    echo "Getting image hsteinshiromoto/docker.tex:latest ..."
    docker pull hsteinshiromoto/docker.tex:latest
    echo "Done"

    echo "Getting image hsteinshiromoto/docker.datascience:latest ..."
    docker pull hsteinshiromoto/docker.datascience:latest
    echo "Done"

    echo "Getting image python:${python_version} ..."
    docker pull python:${python_version}-slim
    echo "Done"
            }

get_images