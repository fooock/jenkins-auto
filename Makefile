ansible-requirements:
	ansible-galaxy collection install -r ansible/requirements.yml

packer-build:
	packer validate packer/so-snapshot.json 
	packer build packer/so-snapshot.json
