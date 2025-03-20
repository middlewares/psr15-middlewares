#!/bin/bash
set -o nounset
set -o errexit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR/setup"

export COMPOSE_BAKE=true
export KIT_UID=$(id -u)
export KIT_GID="$(id -g)"
export KIT_USER="$(whoami)"

docker-compose build --build-arg="KIT_UID=$KIT_UID" \
                    --build-arg="KIT_GID=$KIT_GID" \
                    --build-arg="KIT_USER=$KIT_USER"
