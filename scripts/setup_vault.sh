#!/usr/bin/bash

echo "[INFO] SETUP VAULT..."

if [ -z "${PROJECT_NAME}" ]; then 
	echo "[DEBUG] Env variable PROJECT_NAME is not defined. Abort."
	exit 1
else 
	echo "[DEBUG] PROJECT_NAME is: $PROJECT_NAME"
fi

if [ -z "${ANSIBLE_VAULT_PASSWORD_FILE}" ]; then
	echo "[DEBUG] Env variable ANSIBLE_VAULT_PASSWORD_FILE is not defined. Abort."
	exit 1
else 
	echo "[DEBUG] ANSIBLE_VAULT_PASSWORD_FILE is located at: $ANSIBLE_VAULT_PASSWORD_FILE"
fi



if [ -e "${ANSIBLE_VAULT_PASSWORD_FILE}" ]; then
	echo "[DEBUG] ANSIBLE_VAULT_PASSWORD_FILE as $ANSIBLE_VAULT_PASSWORD_FILE already exists. Abort"
else
	mkdir -p $(dirname ${ANSIBLE_VAULT_PASSWORD_FILE})
	read -s -p "[READ] No vault password file detected for project. Provide PASSWORD to create new vault password file: " VAULT_PWD
	echo "[DEBUG] Password recorded. Success. "
	echo ${VAULT_PWD} > ${ANSIBLE_VAULT_PASSWORD_FILE}
	if [ -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
		echo "[DEBUG] ANSIBLE_VAULT_PASSWORD_FILE created at $ANSIBLE_VAULT_PASSWORD_FILE. Sucess."
	fi
	echo "[DEBUG] #### FAQ:" 
	echo https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data-on-ubuntu-16-04
fi