ANSIBLE_COLLECTIONS_PATH := $(HOME)/.ansible/collections
ANSIBLE_ROLES_PATH := $(HOME)/.ansible/roles

ansible-requirements:
	ansible-galaxy collection install -r ansible/requirements.yml -p $(ANSIBLE_COLLECTIONS_PATH)
	ansible-galaxy role install -r ansible/requirements.yml --roles-path $(ANSIBLE_ROLES_PATH)

packer-build:
	packer validate packer/os-base-snapshot.json 
	packer build packer/os-base-snapshot.json
