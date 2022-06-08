#!/bin/bash

set -euo pipefail
# set -x

main() {
    for s in stable testing next; do
        curl -o "releases-$s.json" "https://builds.coreos.fedoraproject.org/prod/streams/$s/releases.json"
    done
    echo ""
    for s in stable testing next; do
        for rel in $(jq -r '.releases[].version' "releases-$s.json"); do
            if [[ $(grep -cE "^  $rel:$" "$s.yml") -ne 1 ]]; then
                noversion=${rel#*.}
                date=${noversion%%.*}
                if [[ $date -lt 20211016 ]]; then
                    # echo "Skipping missing old release '$rel' in stream '$s'"
                    continue
                fi
                echo "Missing release '$rel' in stream '$s'"
            fi
        done
    done
}

main "${@}"
