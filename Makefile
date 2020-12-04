ansible-requirements:
	ansible-galaxy collection install -r ansible/requirements.yml

packer-build:
	packer validate packer/so-base-snapshot.json 
	packer build packer/so-base-snapshot.json
