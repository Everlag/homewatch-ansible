# homewatch-ansible

Boostrap a [homewatch](https://github.com/chocolateHszd/HomeWatch) instance on a local VM. From no VM to ready to develop should take less than two hours with the majority of time spent in non-interactive waiting.

Please note this is meant for development; production deployment with this playbook unmodified is likely to result in tears.

This repo was initially built with ansible `2.0.0.2` under cygwin. For installation, please head to the bottom.

## Cygwin Installation

For cygwin, you're explicitly unsupported but it usually works! Here's what to do

	# Install, with the cygwin package installer,
	#	curl
	#	python(2.7.x)
	#	python-openssl
	#	python-crypto
	#	python-setuptools
	#	git(~2.5)
	#	nano
	#	openssh
	#	openssl
	#	openssl-devel

	# Run
	easy_install-2.7 pip
	pip install passlib
	pip install ansible

Other platforms should follow the equivalent steps.

## Initial Environment

To bootstrap homewatch using ansible using this guide, several assumptions are made for ease of use. These cannot be reasonably done from within ansible. Deviations from these assumptions may be difficult to correct.

1. Ubuntu server 14.04 is installed in a VM; openSSH server was installed at some point. There should be >=8GB of disk space available for an empty install.

1. A user with sudo privileges is `fisher` with password `fish`.

1. You're using virtualbox with guest port `22` exposed on host port `21351` and guest port `80` exposed on host port `16546`. Ports can be exposed by going to the VM's settings, Network tab, and Port Forwarding at the bottom of the adapter config panel.

1. You've run `aptitude update && aptitude -y upgrade`. If you don't upgrade, you will get some nasty errors that you don't want to deal with. This will take a long time so read a book or something.

At this point, `ssh -p 21351 fisher@localhost` should get you into a brand new install of ubuntu. You should do this to register the VM's keypair.
## One Off Config

Bootstrapping a server into this ansible config is relatively painless.

In inventory.antsy.ini, replace the default `localhost:21351` with the correct `server:port` line if you deviated from the post established above.

Perform a connection test using `ansible all -m ping --ask-pass -i inventory.antsy.ini -u fisher --ask-pass --ask-sudo-pass --ask-become-pass -c paramiko`

## Usage

Run

	ansible-playbook bootstrap.yml -i inventory.antsy.ini -u fisher --ask-pass --ask-sudo-pass --ask-become-pass -c paramiko

to bootstrap homewatch. This should handle using cygwin and password authentication without issues. You'll be prompted for the same password twice then the rest of the process should be non-interactive.

When the playbook completes, you should be able to access homewatch at [localhost:16546/HomeWatch/](http://localhost:16546/HomeWatch/)

## Security

The aim of this repo is to be explicitly easy to develop on, do not expect this to be secure in any way for production deployments.

If you're exposing a system that's using this playbook to anything potentially hostile, its probably a good idea to change the mysql root password after using this to bootstrap. To do so, change the root password as usual in mysql then change the homewatch password in `/var/www/HomeWatch/www/config/config.local.php`.

You'll probably want to tighten permissions in `/var/www/HomeWatch/` as well as change passwords.

## Misc

### Password Authentication

Ansible likes to use sshkeys because they are better in every way. If you're a gristly curmudgeon, append `--ask-pass --ask-sudo-pass --ask-become-pass -c paramiko` to any command to use passwords. This command means that you supply a password for both ssh and sudo upfront and explicitly avoid a dependency on sshpass.