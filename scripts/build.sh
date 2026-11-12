#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 || ${1:-} == --help || ${1:-} == -h ]]; then
    echo "Gebruik: $0 [baseurl]"
    echo "Bouw de site in _site en controleer lokale links. Standaard is baseurl leeg."
    if [[ $# -gt 1 ]]; then
        exit 1
    fi
    exit 0
fi

baseurl=${1:-}
if [[ -n "$baseurl" && ( "$baseurl" != /* || "$baseurl" == //* ) ]]; then
    echo "baseurl moet leeg zijn of een pad zoals /cursus-vr-visualization." >&2
    exit 1
fi
baseurl=${baseurl%/}

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd -- "$project_dir"

for tool in jekyll python3; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "$tool ontbreekt. Start eerst de ontwikkelomgeving met nix develop." >&2
        exit 1
    fi
done

jekyll build --baseurl "$baseurl" --destination "$project_dir/_site"
python3 scripts/check_site.py "$project_dir/_site" --baseurl "$baseurl"
