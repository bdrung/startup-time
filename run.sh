#!/bin/sh
set -e

runs=$1
shift
for i in $(seq $runs); do
    $@ > /dev/null
done
