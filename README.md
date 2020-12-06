# Jenkins provisioning

>:construction: Work in progress

Install and configure Jenkins in an automated way in dedicated machines. You will need a [Hetzner]() account in
order to use this scripts.

You need to set an environment variable called `HCLOUD_TOKEN` in order to create all needed resources.

>:moneybag: Keep in mind that you may be charged by the cloud provider if you use this repository. 

## Tools you need

In order to execute this scripts you will need to have installed in your computer:

* [Ansible](https://www.ansible.com/) version ` 2.9.15`
* [GNU Make](https://www.gnu.org/software/make/) version `4.1`
* [Packer](https://www.packer.io/) version `1.6.5`

## How to

First you need to have all requirements installed on your local machine. When done, you need
to execute this directive:

```bash
$ make ansible-requirements
```

>This will install all required roles and collections needed to provision the base images.

Now you can execute the directive required to generate the base image with the common components to run
a Jenkins instance.

```bash
$ make packer-build
```
