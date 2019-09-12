#!/usr/bin/env bash

set -euo pipefail

# =================================================================== #
# Configuration
# ------------------------------------------------------------------- #

NODEJS_KEYS_REPO="canterberry/nodejs-keys"

# =================================================================== #
# Functions
# ------------------------------------------------------------------- #

nodejs_keys_list() {
  curl -sSL "https://raw.githubusercontent.com/${NODEJS_KEYS_REPO}/master/keys.list"
}

nodejs_keys_clear() {
  for KEY_ID in $(nodejs_keys_list | xargs); do
    printf "."
    gpg --batch --delete-key "${KEY_ID}"
  done
  echo 'done'
}

nodejs_keys_import() {
  for KEY_ID in $(nodejs_keys_list | xargs); do
    curl -sSL "https://raw.githubusercontent.com/${NODEJS_KEYS_REPO}/master/keys/${KEY_ID}.asc" | gpg --import
  done
}

nodejs_keys_usage() {
  >&2 cat <<EOF
USAGE: $0 clear|help|import

Manages Node.js release signing keys.

COMMANDS:

  clear   Clears all Node.js release signing keys from the GPG keyring.
  help    Displays this help message.
  import  Imports all Node.js release signing keys to the GPG keyring. (default)

EOF
  exit 1
}

# =================================================================== #
# Requirements
# ------------------------------------------------------------------- #

if [ -z "$(which gpg)" ]; then
  >&2 echo "Missing required executable: gpg"
  exit 1
fi

if [ -z "$(which curl)" ]; then
  >&2 echo "Missing required executable: curl"
  exit 1
fi

# =================================================================== #
# Entry Point
# ------------------------------------------------------------------- #

COMMAND_NAME="help"

if [ "$#" -gt 0 ]; then
  COMMAND_NAME="$1"
fi

case "${COMMAND_NAME}" in
  clear)
    nodejs_keys_clear
    ;;
  import)
     nodejs_keys_import
    ;;
  *)
    nodejs_keys_usage
    ;;
esac
