#!/usr/bin/env bash

python_version=${python_version:-3.9-slim}

get_images(){
    echo "Getting image hsteinshiromoto/docker.tex:latest ..."
    docker pull hsteinshiromoto/docker.tex:latest
    echo "Done"

    echo "Getting image hsteinshiromoto/docker.datascience:latest ..."
    docker pull hsteinshiromoto/docker.datascience:latest
    echo "Done"

    echo "Getting image python:${python_version} ..."
    docker pull python:${python_version}
    echo "Done"
            }

get_images