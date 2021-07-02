#!/usr/bin/env bash

set -euo pipefail

# =================================================================== #
# Configuration
# ------------------------------------------------------------------- #

NODEJS_KEYS_REPO="nodejs/release-keys"
CLI_DIR="$(cd "$(dirname "$0")"; pwd)"

# =================================================================== #
# Functions
# ------------------------------------------------------------------- #

nodejs_keys_fetch() {
  local KEY_ID="$1"

  if [ -f "${CLI_DIR}/keys/${KEY_ID}.asc" ]; then
    cat "${CLI_DIR}/keys/${KEY_ID}.asc"
  else
    curl -sSL "https://raw.githubusercontent.com/${NODEJS_KEYS_REPO}/HEAD/keys/${KEY_ID}.asc"
  fi
}

nodejs_keys_list() {
  if [ -f "${CLI_DIR}/keys.list" ]; then
    cat "${CLI_DIR}/keys.list"
  else
    curl -sSL "https://raw.githubusercontent.com/${NODEJS_KEYS_REPO}/HEAD/keys.list"
  fi
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
    nodejs_keys_fetch "${KEY_ID}" | gpg --import
  done
}

nodejs_keys_add() {
  if [ $# -lt 1 ]; then
    nodejs_keys_usage
  fi

  KEY_ID="$1"

  gpg --export --armor "${KEY_ID}" > "${CLI_DIR}/keys/${KEY_ID}.asc"

  GNUPGHOME="${CLI_DIR}/gpg" gpg --import "${CLI_DIR}/keys/${KEY_ID}.asc"

  printf "keys.list <- "
  if grep --quiet "${KEY_ID}" "${CLI_DIR}/keys.list"; then
    echo "${KEY_ID}"
  else
    echo "${KEY_ID}" | tee -a "${CLI_DIR}/keys.list"
  fi
}

nodejs_keys_usage() {
  >&2 cat <<EOF
USAGE: $0 clear|help|import|add

Manages Node.js release signing keys.

COMMANDS:

  clear   Clears all Node.js release signing keys from the GPG keyring.
  help    Displays this help message.
  import  Imports all Node.js release signing keys to the GPG keyring. (default)
  add     Adds a release signing key to this repo.

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
  shift
fi

case "${COMMAND_NAME}" in
  clear)
    nodejs_keys_clear
    ;;
  import)
     nodejs_keys_import
    ;;
  add)
    nodejs_keys_add "$@"
    ;;
  *)
    nodejs_keys_usage
    ;;
esac
