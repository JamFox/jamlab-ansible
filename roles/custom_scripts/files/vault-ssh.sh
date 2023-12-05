#!/bin/bash
# {{ ansible_managed }}

set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 user@host [-p 22]"
    exit 1
fi

if [[ "$1" =~ ^-+ ]]; then
    echo "Error: Additional SSH flags must be passed after the hostname. e.g. '$0 user@host -p 2222'"
    exit 1
fi

VAULT_VARS_FILE="$HOME/.vault-vars"

# Check if the file exists
if [ -e "$VAULT_VARS_FILE" ]; then
    source "$VAULT_VARS_FILE"
else
    echo "Error: $VAULT_VARS_FILE does not exist."
    echo "Did you forget to run vault-login?"
    exit 1
fi

ssh -i ${VAULT_SIGNED_KEY} -i ${VAULT_SSH_KEY} ${1} ${@:2}
