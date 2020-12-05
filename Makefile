ansible-requirements:
	ansible-galaxy collection install -r ansible/requirements.yml

packer-build:
	packer validate packer/os-base-snapshot.json 
	packer build packer/os-base-snapshot.json
