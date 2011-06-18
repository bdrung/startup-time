#!/bin/sh
set -e

for i in $(seq $1); do
    $2 $3 > /dev/null
done
