ANSIBLE_COLLECTIONS_PATH := $(HOME)/.ansible/collections
ANSIBLE_ROLES_PATH := $(HOME)/.ansible/roles
ANSIBLE_TEST_INVENTORY_PATH := ansible/inventory-test
ANSIBLE_SERVER_USER := root
ANSIBLE_SERVER_HOST :=
ANSIBLE_EXTRA := 

TERRAFORM_SSH_KEYS := ["sshkey"]

install-requirements: ansible-requirements terraform-init

ansible-requirements:
	ansible-galaxy collection install -r ansible/requirements.yml -p $(ANSIBLE_COLLECTIONS_PATH)
	ansible-galaxy role install -r ansible/requirements.yml --roles-path $(ANSIBLE_ROLES_PATH)

ansible-check:
	ansible-playbook -i localhost, ansible/playbook.yml --syntax-check

ansible-run:
ifeq ($(ANSIBLE_SERVER_HOST),)
	$(error Use: make ansible-run ANSIBLE_SERVER_HOST=xxx.xxx.xxx.xxx)
endif
	ansible-playbook -i $(ANSIBLE_SERVER_HOST), -u $(ANSIBLE_SERVER_USER) ansible/playbook.yml $(ANSIBLE_EXTRA)

packer-build:
	packer validate packer/os-base-snapshot.json 
	packer build packer/os-base-snapshot.json

terraform-init:
	terraform init terraform

terraform-check:
	terraform validate terraform
	terraform fmt terraform

terraform-apply:
	terraform apply \
	-var 'ssh_keys=$(TERRAFORM_SSH_KEYS)' \
	-var 'jenkins_base_snapshot=$(shell jq -r '.builds[-1].artifact_id' base-manifest.json | cut -d ":" -f2)' \
	-var 'hcloud_token=$(HCLOUD_TOKEN)' \
	terraform

terraform-destroy:
	terraform destroy \
	-var 'ssh_keys=$(TERRAFORM_SSH_KEYS)' \
	-var 'jenkins_base_snapshot=$(shell jq -r '.builds[-1].artifact_id' base-manifest.json | cut -d ":" -f2)' \
	-var 'hcloud_token=$(HCLOUD_TOKEN)' \
	terraform
