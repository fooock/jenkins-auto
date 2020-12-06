# Jenkins provisioning

>:construction: Work in progress

Install and configure Jenkins in an automated way using the [Hetzner](https://console.hetzner.cloud/projects) cloud provider.

You need to set an environment variable called `HCLOUD_TOKEN` in order to create all remote resources.

>:moneybag: Keep in mind that you may be charged by the cloud provider if you use this repository. 

## Tools you need

To execute this scripts you will need to have installed in your computer:

* [Ansible](https://www.ansible.com/) version ` 2.9.15`
* [GNU Make](https://www.gnu.org/software/make/) version `4.1`
* [Packer](https://www.packer.io/) version `1.6.5`
* [Terraform](https://registry.terraform.io/) version `0.14.0`

## How to

First you need to have all requirements installed on your local machine. Execute this directive:

```bash
$ make install-requirements
```

>This will install all required roles and collections needed to provision the base images.

Now you can execute the required directive to generate the base image with the common components to run
a Jenkins instance.

```bash
$ make packer-build
```

The last step is to provision the resources using terraform. Just execute this command:

```bash
$ make terraform-apply TERRAFORM_SSH_KEYS='["your_sshkey"]'
```

>**Important** :exclamation:
>Change `your_sshkey` from the correct value of your Hetznet cloud security SSH keys.
