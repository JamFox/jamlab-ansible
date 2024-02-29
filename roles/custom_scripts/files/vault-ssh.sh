#!/bin/bash
# This script uses the vault signed SSH key to log in to a remote host.

# You need to be an authorized principal on remote host to successfully log in.

# Before using: run 'vault-login' script to log in to Vault to generate the VAULT_VARS_FILE file and create signed key.
# This script should also be symlinked as 'vssh' for your convenience.
# Usage exactly as you would use 'ssh': vault-ssh user@host [optional ssh args]

set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 user@host [optional ssh args]"
    echo "Run 'vault-login' before to generate the VAULT_VARS_FILE file and create signed key."
    exit 1
fi

VAULT_VARS_FILE="$HOME/.vault-vars"

# Check if the file exists
if [ -e "$VAULT_VARS_FILE" ]; then
    source "$VAULT_VARS_FILE"
else
    echo "Error: $VAULT_VARS_FILE does not exist."
    echo "Did you forget to run 'vault-login'?"
    exit 1
fi

current_time=$(date +%s)
eight_hours_in_minutes=$((8 * 60))
if find "$VAULT_SIGNED_KEY" -mmin +$eight_hours_in_minutes | grep -q .; then
    echo "$VAULT_SIGNED_KEY was last modified over 8 hours ago, it has probably expired."
    echo "Run 'vault-login' again to generate a new signed key."
    echo "Do you want to continue anyway? (y/n)"
    read user_input
    # Convert user input to lowercase for case-insensitive comparison
    user_input_lower=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
    if [ "$user_input_lower" == "y" ]; then
        echo "Continuing..."
    else
        echo "Exiting."
        exit 0
    fi
fi

ssh -o PreferredAuthentications=publickey -o IdentitiesOnly=yes -i ${VAULT_SIGNED_KEY} -i ${VAULT_SSH_KEY} ${@}
if [ $? -ne 0 ]; then
    echo "Check the following:"
    echo "  - Is your $VAULT_SIGNED_KEY key still valid?"
    echo "  - Are you an authorized principal on the remote host user?"
fi
