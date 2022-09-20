export PROJECT_NAME = $(shell basename $(PWD))
export ANSIBLE_VAULT_PASSWORD_FILE = ${HOME}/.ansible/vaults/${PROJECT_NAME}

.PHONY: ${TARGETS}

PLAY=ANSIBLE_NOCOWS=1 ansible-playbook starter.yml
MASTER=$(PLAY) -i inventories/master 
SLAVES=$(PLAY) -i inventories/slaves 
CLUSTER=$(PLAY) -i inventories

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
clustervvvv: 
	$(CLUSTER) -vvvv
check: 
	$(PLAY) --syntax-check

all: setup check  cluster 
allv: setup check clusterv
allvvvv: setup check clustervvvv
alld: setup check clusterd
