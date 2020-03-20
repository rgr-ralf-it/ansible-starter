export PROJECT_NAME = $(shell basename $(PWD))
export ANSIBLE_VAULT_PASSWORD_FILE = ${HOME}/.ansible/vaults/${PROJECT_NAME}

.PHONY: ${TARGETS}

MASTER=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories/master 
SLAVES=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories/slaves 
CLUSTER=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories

setup:
	echo ${PROJECT_NAME}
	bash scripts/install_ansible.sh 
	bash scripts/setup_vault.sh 
	bash scripts/encrypt_credentials.sh

master: 
	$(MASTER)
slaves: 
	$(SLAVES)
slavesv: 
	$(SLAVES) -vvvv
cluster: 
	$(CLUSTER)
clusterv: 
	$(CLUSTER) -v
check: 
	$(PLAY) --syntax-check

all: setup check play
