#!/bin/bash

# This script allow to test renovate config updates locally

set -e
cd $(dirname "$0")
docker run -it --rm -v "$PWD":/data -w /data -e LOG_LEVEL=debug \
 -e RENOVATE_GITHUB_COM_TOKEN=${RENOVATE_GITHUB_COM_TOKEN} \
 renovate/renovate --platform=local

