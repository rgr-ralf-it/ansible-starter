export PYTHON_DIR=$(shell which python)
export PYTHON_VER=$(shell ${PYTHON_DIR} -c 'import sys; print(".".join(map(str,sys.version_info[:2])))')
export PYTHON_LIBRARY=$(shell ${PYTHON_DIR} -c "from sysconfig import get_paths; print(get_paths()['stdlib'])")
export PYTHON_INCLUDE_DIR=$(shell ${PYTHON_DIR} -c "from sysconfig import get_paths; print(get_paths()['include'])")
export PYTHON_SITEPACKAGES=$(shell ${PYTHON_DIR} -c "from sysconfig import get_paths; print(get_paths()['purelib'])")
export PYTHON_EXECUTABLE=${PYTHON_DIR}

export PROJECT_NAME = $(shell basename $(PWD))
export ANSIBLE_VAULT_PASSWORD_FILE = ${HOME}/.ansible/vaults/${PROJECT_NAME}
export BROADCAST = $(shell ${PYTHON_DIR} scripts/find_broadcast.py)

.PHONY: ${TARGETS}

MASTER=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories/master 
SLAVES=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories/slaves 
CLUSTER=ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories
WOL=ANSIBLE_NOCOWS=1 ansible-playbook wol.yml -i inventories/master

check-env:
ifndef PYTHON_DIR
	$(error PYTHON_DIR is undefined)
endif
ifndef BROADCAST
	$(error BROADCAST is undefined)
endif
ifndef PROJECT_NAME
	$(error PROJECT_NAME is undefined)
endif
ifndef ANSIBLE_VAULT_PASSWORD_FILE
	$(error ANSIBLE_VAULT_PASSWORD_FILE is undefined)
endif

setup:
	echo ${PROJECT_NAME}
	bash scripts/install_ansible.sh 
	bash scripts/setup_vault.sh 
	bash scripts/encrypt_credentials.sh
wol: check-env
	@echo "[PLAY] wake on lan"
	$(WOL)
wait: check-env
	python3 scripts/wait_for_nodes.py
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

all: setup check-env wol wait slaves
