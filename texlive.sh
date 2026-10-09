#!/usr/bin/env bash
# Run a command in the upstream TeX Live image from anywhere in the project.
set -euo pipefail

if [ "$#" -eq 0 ]; then
    echo "usage: $(basename "$0") <command> [args...]" >&2
    exit 1
fi

root="$(cd "$(dirname "$0")" && pwd -P)"
cwd="$(pwd -P)"
case "$cwd/" in
    "$root"/*) ;;
    *) echo "$(basename "$0"): run it from inside $root" >&2; exit 1 ;;
esac

image="${TEXLIVE_IMAGE:-registry.gitlab.com/islandoftex/images/texlive:TL2026-2026-08-16-full}"
source_date_epoch="${SOURCE_DATE_EPOCH:-0}"

exec podman run --rm --userns=keep-id \
    -v "$root:/work:z" -w "/work${cwd#"$root"}" \
    -e "SOURCE_DATE_EPOCH=$source_date_epoch" -e FORCE_SOURCE_DATE=1 -e TZ=UTC \
    -e 'GS_OPTIONS=-dOmitInfoDate=true -dOmitID=true -dOmitXMP=true' \
    "$image" "$@"
