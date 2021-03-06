ANSIBLE_COLLECTIONS_PATH := $(HOME)/.ansible/collections
ANSIBLE_ROLES_PATH := $(HOME)/.ansible/roles
ANSIBLE_TEST_INVENTORY_PATH := ansible/inventory-test
ANSIBLE_SERVER_USER := root
ANSIBLE_SERVER_HOST :=
ANSIBLE_EXTRA := 
ANSIBLE_PLAYBOOK_NAME := base

TERRAFORM_SSH_KEYS := ["sshkey"]

JENKINS_AUTH_USER := jenkins
JENKINS_AUTH_PASSWORD := password

install-requirements: ansible-requirements terraform-init

generate-jenkins-auth:
	JENKINS_AUTH_USER=$(JENKINS_AUTH_USER) \
	JENKINS_AUTH_PASSWORD=$(JENKINS_AUTH_PASSWORD) \
	envsubst \
	'$${JENKINS_AUTH_USER} $${JENKINS_AUTH_PASSWORD}' \
	< local/scripts/auth-user.tpl > local/scripts/auth-user.groovy

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
	ansible-playbook -i localhost, ansible/base-playbook.yml --syntax-check
	ansible-playbook -i localhost, ansible/master-playbook.yml --syntax-check

ansible-run: generate-jenkins-auth
ifeq ($(ANSIBLE_SERVER_HOST),)
	$(error Use: make ansible-run ANSIBLE_SERVER_HOST=xxx.xxx.xxx.xxx)
endif
	ansible-playbook -i $(ANSIBLE_SERVER_HOST), \
	-u $(ANSIBLE_SERVER_USER) \
	ansible/$(ANSIBLE_PLAYBOOK_NAME)-playbook.yml \
	$(ANSIBLE_EXTRA)

#                   _             
#                  | |            
#  _ __   __ _  ___| | _____ _ __ 
# | '_ \ / _` |/ __| |/ / _ \ '__|
# | |_) | (_| | (__|   <  __/ |   
# | .__/ \__,_|\___|_|\_\___|_|   
# | |                             
# |_|                             
#

packer-check:
	packer validate packer/os-base-snapshot.json
	packer validate packer/os-master-snapshot.json 

packer-build: generate-jenkins-auth
	packer build packer/os-base-snapshot.json
	packer build packer/os-master-snapshot.json

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
	-var 'hcloud_token=$(HCLOUD_TOKEN)' \
	terraform

terraform-destroy:
	terraform destroy \
	-var 'ssh_keys=$(TERRAFORM_SSH_KEYS)' \
	-var 'hcloud_token=$(HCLOUD_TOKEN)' \
	terraform

#  _                 _ 
# | |               | |
# | | ___   ___ __ _| |
# | |/ _ \ / __/ _` | |
# | | (_) | (_| (_| | |
# |_|\___/ \___\__,_|_|
#                      

local-jenkins-start: generate-jenkins-auth
	docker run --rm -d \
	--name jenkins \
	-p 127.0.0.1:8080:8080 \
	-p 127.0.0.1:50000:50000 \
	-v jenkins_home:/var/jenkins_home \
	-v $(shell pwd)/local/scripts:/usr/share/jenkins/ref/init.groovy.d/ \
	-v $(shell pwd)/local/jenkins.install.UpgradeWizard.state:/var/jenkins_home/jenkins.install.UpgradeWizard.state \
	jenkins/jenkins:lts

local-jenkins-stop:
	docker stop jenkins
	docker rm jenkins
