#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ROOT_DIR="$DIR/../"

set -e

# go to root, all composer, phpcs, etc. commands will be run there
cd "$ROOT_DIR"

version="$1"

if ( cat composer.json | grep '^7.2 || ^8.0' &> /dev/null ); then
    declare -a phps=("7.2" "7.3" "7.4" "8.0" "8.1" "8.2" "8.3" "8.4")
elif ( cat composer.json | grep '>=8.1' &> /dev/null ); then
    declare -a phps=("8.1" "8.2" "8.3" "8.4")
fi

#declare -a phps=("8.3")

verbose="0"
if [[ "$*" == *"--verbose"* ]] || [[ "$*" == *"-v"* ]]; then
    verbose="1"
fi

for php in "${phps[@]}"; do

    echo '============================================='
    echo "> [PHP $php]"
    echo '============================================='

    sudo update-alternatives --set php "/usr/bin/php${php}" &> /dev/null

    if [[ $verbose -eq 1 ]]; then
    echo "1"
    exit
        composer update --prefer-dist
    else
        composer update --no-progress
        if [[ $? -ne 0 ]]; then
           echo "Error on composer update. Enable verbose mode: --verbose or -v"
        fi
    fi

    composer run phpstan

    php vendor/bin/phpunit


    if [[ "$php" = "8.3" ]]; then
        echo "running cs-fix with php8.3"
        composer run cs
        composer run cs-fix
    fi
done
