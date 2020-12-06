ANSIBLE_COLLECTIONS_PATH := $(HOME)/.ansible/collections
ANSIBLE_ROLES_PATH := $(HOME)/.ansible/roles
ANSIBLE_TEST_INVENTORY_PATH := ansible/inventory-test
ANSIBLE_SERVER_USER := root
ANSIBLE_SERVER_HOST :=
ANSIBLE_EXTRA := 

TERRAFORM_SSH_KEYS := ["sshkey"]

install-requirements: ansible-requirements terraform-init

#                  _ _     _      
#                 (_) |   | |     
#   __ _ _ __  ___ _| |__ | | ___ 
#  / _` | '_ \/ __| | '_ \| |/ _ \
# | (_| | | | \__ \ | |_) | |  __/
#  \__,_|_| |_|___/_|_.__/|_|\___|
#                                 

ansible-requirements:
	ansible-galaxy collection install -f -r ansible/requirements.yml -p $(ANSIBLE_COLLECTIONS_PATH)
	ansible-galaxy role install -f -r ansible/requirements.yml --roles-path $(ANSIBLE_ROLES_PATH)

ansible-check:
	ansible-playbook -i localhost, ansible/playbook.yml --syntax-check

ansible-run:
ifeq ($(ANSIBLE_SERVER_HOST),)
	$(error Use: make ansible-run ANSIBLE_SERVER_HOST=xxx.xxx.xxx.xxx)
endif
	ansible-playbook -i $(ANSIBLE_SERVER_HOST), -u $(ANSIBLE_SERVER_USER) ansible/playbook.yml $(ANSIBLE_EXTRA)

#                   _             
#                  | |            
#  _ __   __ _  ___| | _____ _ __ 
# | '_ \ / _` |/ __| |/ / _ \ '__|
# | |_) | (_| | (__|   <  __/ |   
# | .__/ \__,_|\___|_|\_\___|_|   
# | |                             
# |_|                             
#

packer-build:
	packer validate packer/os-base-snapshot.json 
	packer build packer/os-base-snapshot.json


#  _                       __                     
# | |                     / _|                    
# | |_ ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___  
# | __/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \ 
# | ||  __/ |  | | | (_| | || (_) | |  | | | | | |
#  \__\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_|
#                                                 

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

#  _                 _ 
# | |               | |
# | | ___   ___ __ _| |
# | |/ _ \ / __/ _` | |
# | | (_) | (_| (_| | |
# |_|\___/ \___\__,_|_|
#                      

local-jenkins-start:
	docker run -d \
	--name jenkins \
	-p 127.0.0.1:8080:8080 \
	-p 127.0.0.1:50000:50000 \
	-v local:/var/jenkins_home \
	jenkins/jenkins:lts

local-jenkins-stop:
	docker stop jenkins
	docker rm jenkins
