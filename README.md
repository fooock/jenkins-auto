# Jenkins provisioning

>:construction: Work in progress

Install and configure Jenkins in an automated way in dedicated machines. You will need a [Hetzner]() account in
order to use this scripts.

You need to set an environment variable called `HCLOUD_TOKEN` in order to create all needed resources.

>:moneybag: Keep in mind that if you use this you may be charged. 

## How to

First you need to have all requirements installed on your local machine. When done, you need
to execute this directive:

```bash
$ make ansible-requirements
```

>This will install all required roles and collections needed to provision the base images.
