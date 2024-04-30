#!/bin/bash
# This script logs in to Vault and saves the token and other variables to a VAULT_VARS_FILE file.
# Prerequisites: 'vault' must be installed: https://developer.hashicorp.com/vault/install

# Source VAULT_VARS_FILE after successful login to use 'vault' commands.
# This script should also be symlinked as 'vl' for your convenience.

# Usage: vault-login username -h -i VAULT_SSH_KEY -a 
# Arguments:
#   username (Required): The username to log in to Vault.
#   -h Prints help
#   -i VAULT_SSH_KEY (Optional): Path to the SSH private key to sign. If not provided, the script will not sign an SSH key.
#   -a Adds signed key to agent

set -e

# Usage display function
Help()
{
   echo "Script logs in to Vault and saves authentication variables to a VAULT_VARS_FILE file."
   echo "Optionally signs SSH key and adds it to SSH agent."
   echo
   echo "Usage:"
   echo " $0 <USERNAME> [-h] [-i <PATH>] [-a]"
   echo "Options:"
   echo " -h    Print this help and exit"
   echo " -i    Path to the SSH private key to sign"
   echo " -a    Add certificate to the SSH agent"
   echo
}

# Parse command line arguments
add_cert_to_agent=false
while [[ -n $1 ]]
do
    case $1 in
    (-h)
        Help
        exit 0
    ;;
    (-i)
        shift
        VAULT_SSH_KEY=$1
        # Check if the key file exists
        if [ ! -f "$VAULT_SSH_KEY" ]; then
          echo "Error: File $VAULT_SSH_KEY does not exist."
          exit 1
        fi
        VAULT_SSH_KEY=$(readlink -f "$VAULT_SSH_KEY")
        VAULT_SSH_KEY=${VAULT_SSH_KEY%.pub}
    ;;
    (-a)
        add_cert_to_agent=true
    ;;
    (*)
        USERNAME=$1
    ;;
  esac
  shift
done

# Check if the required argument "username" is provided
if [ -z "$USERNAME" ]; then
  echo "Error: Missing required argument USERNAME."
  echo "Usage: $0 <USERNAME> [-i VAULT_SSH_KEY]"
  exit 1
fi

# Check for vault install
if ! command -v vault &> /dev/null ; then
    echo "Vault is not installed."
    echo "Check https://developer.hashicorp.com/vault/install"
    exit 1
fi

# Define the file path
VAULT_VARS_FILE="$HOME/.vault-vars"

# Check if the file exists, if not, create it
if [ ! -f "$VAULT_VARS_FILE" ]; then
  touch "$VAULT_VARS_FILE"
  chmod 600 "$VAULT_VARS_FILE"
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
VAULT_USER=$USERNAME
echo "Logging in to $VAULT_ADDR as $VAULT_USER"
VAULT_TOKEN=$(vault login -address=$VAULT_ADDR -method=userpass username=$VAULT_USER | grep -o 'hvs\.[^[:space:]]*')

update_variable "VAULT_ADDR"
update_variable "VAULT_USER"
update_variable "VAULT_TOKEN"

if [ -n "$VAULT_SSH_KEY" ]; then
  echo "Signing SSH key $VAULT_SSH_KEY"
  VAULT_SIGNED_KEY=$VAULT_SSH_KEY-cert.pub
  vault write -address=$VAULT_ADDR -field=signed_key ssh-client-signer/sign/ssh_admin public_key=@${VAULT_SSH_KEY}.pub valid_principals=$VAULT_USER > $VAULT_SIGNED_KEY
  if [ $? -ne 0 ]; then
    echo "Error: failed to sign the SSH key."
    exit 1
  else
    echo "Signed SSH key saved to $VAULT_SIGNED_KEY"
    update_variable "VAULT_SSH_KEY"
    update_variable "VAULT_SIGNED_KEY"
    if [[ $add_cert_to_agent == true ]]
    then
      echo "Adding certificate to the SSH agent"
      ssh-add $VAULT_SSH_KEY
    fi
  fi
else
  echo "No SSH key provided, skipping signing."
fi

echo ""
echo "To use vault commands, run: source $VAULT_VARS_FILE"
