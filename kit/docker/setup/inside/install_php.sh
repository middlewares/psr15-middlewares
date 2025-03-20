#!/usr/bin/env bash

declare -a phps=("7.2" "7.3" "7.4" "8.0" "8.1" "8.2" "8.3" "8.4")

declare -a exts=("xdebug" "gd" "curl" "mbstring" "zip" "tidy" "xml" "dom" "tokenizer" "xmlwriter" "bcmath" "bz2" "intl")

# command="apt install --no-install-recommends -y"
command="apt install --no-install-recommends -y"

for php in "${phps[@]}"; do
    command+=" php${php}"

    for ext in "${exts[@]}"; do
        command+=" php${php}-${ext}"
    done
done

eval "$command"

# apt-get install -y php-memcache php-memcached php-redis  > /dev/null

