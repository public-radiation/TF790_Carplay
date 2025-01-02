#!/bin/bash

WORKSPACE=$PWD
docker run --privileged \
        --interactive \
        --tty \
        --rm \
        --volume=/tmp:/tmp \
        --volume=${WORKSPACE}:/tina \
        --env WORKFOLDER=/tina \
        --hostname tina-build \
        allwinner-tina:latest