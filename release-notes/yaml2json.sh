#!/bin/bash

set -euo pipefail
# set -x

main() {
    for s in next stable testing; do
        cat $s.yml | yq e -o json -P > $s.json;
    done
}

main "${@}"
