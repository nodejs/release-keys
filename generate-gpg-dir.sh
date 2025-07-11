#!/bin/sh

set -ex

GNUPGHOME=${1:-"$(cd "$(dirname "$0")"; pwd)/gpg"}
ONLY_ACTIVE_KEYS=${2:-"$GNUPGHOME-only-active-keys"}

if [ -d "$GNUPGHOME" ]; then
  # If folder exists, move it to a temp dir
  # Removing it could be dangerous
  TRASH=$(mktemp -d)
  mv "$GNUPGHOME" "$TRASH"
fi
if [ -d "$ONLY_ACTIVE_KEYS" ]; then
  # If folder exists, move it to a temp dir
  # Removing it could be dangerous
  TRASH=$(mktemp -d)
  mv "$ONLY_ACTIVE_KEYS" "$TRASH"
fi

mkdir -p "$GNUPGHOME"

awk -F'`' '/^<!-- Active releasers keys -->$/,/^<!-- .Active releasers keys -->$/ {if($1 == "  [") print substr($3, 3, length($3) - 3) }' README.md | while read -r KEY_PATH; do
  GNUPGHOME="$GNUPGHOME" gpg --import "$KEY_PATH"
done

cp -R "$GNUPGHOME" "$ONLY_ACTIVE_KEYS"

awk -F'`' '/^<!-- Retired keys -->$/,/^<!-- .Retired keys -->$/ {if($1 == "  [") print substr($3, 3, length($3) - 3) }' README.md | while read -r KEY_PATH; do
  GNUPGHOME="$GNUPGHOME" gpg --import "$KEY_PATH"
done
