#!/bin/bash
# {{ ansible_managed }}

set -e

# Parse command line arguments
while getopts ":i:" opt; do
  case ${opt} in
    i )
      VAULT_SSH_KEY=$OPTARG
      # Check if the key file exists
      if [ ! -f "$VAULT_SSH_KEY" ]; then
        echo "Error: File '$VAULT_SSH_KEY' does not exist."
        exit 1
      fi
      VAULT_SSH_KEY=$(readlink -f "$VAULT_SSH_KEY")
      ;;
    \? )
      echo "Usage: $0 -i VAULT_SSH_KEY username"
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument."
      echo "Usage: $0 -i VAULT_SSH_KEY username"
      exit 1
      ;;
  esac
done

# Shift the options so that $1 refers to the first non-option argument
shift $((OPTIND -1))

# Check if the required argument "username" is provided
if [ -z "$1" ]; then
  echo "Error: Missing required argument 'username'."
  echo "Usage: $0 -i VAULT_SSH_KEY username"
  exit 1
fi

# Define the file path
VAULT_VARS_FILE="$HOME/.vault-vars"

# Check if the file exists, if not, create it
if [ ! -f "$VAULT_VARS_FILE" ]; then
  touch "$VAULT_VARS_FILE"
fi

# Update or add variables to the file
function update_variable() {
  local var_name=$1
  local var_value=$(eval echo "\$$var_name")

  if grep -q "^export $var_name=" "$VAULT_VARS_FILE"; then
    # Variable exists, update its value
    sed -i "s|^export $var_name=.*$|export $var_name=\"$var_value\"|" "$VAULT_VARS_FILE"
  else
    # Variable does not exist, add it
    echo "export $var_name=\"$var_value\"" >> "$VAULT_VARS_FILE"
  fi
}

VAULT_ADDR="${VAULT_ADDR:-https://vault.hpclocal}"
VAULT_USER=$1
echo "Logging in to $VAULT_ADDR as $VAULT_USER"
VAULT_TOKEN=$(vault login -address=$VAULT_ADDR -method=userpass username=$VAULT_USER | grep -o 'hvs\.[^[:space:]]*')

update_variable "VAULT_ADDR"
update_variable "VAULT_USER"
update_variable "VAULT_TOKEN"

if [ -n "$VAULT_SSH_KEY" ]; then
  echo "Signing SSH key $VAULT_SSH_KEY"
  VAULT_SIGNED_KEY=$HOME/.ssh/vault_signed.pub
  vault write -address=$VAULT_ADDR -field=signed_key ssh-client-signer/sign/ssh_admin public_key=@${VAULT_SSH_KEY}.pub valid_principals=$VAULT_USER > $VAULT_SIGNED_KEY
  if [ $? -ne 0 ]; then
    echo "Error: failed to sign the SSH key."
    exit 1
  else
    echo "Signed SSH key saved to $VAULT_SIGNED_KEY"
    update_variable "VAULT_SSH_KEY"
    update_variable "VAULT_SIGNED_KEY"
  fi
fi

echo "To use vault commands, run: source $VAULT_VARS_FILE"
