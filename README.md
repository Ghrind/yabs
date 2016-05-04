# YABS

## Features

### What I need:

* List what folders of this machine will be saved and where
* Backup the folders on a regular schedule
* Show the last backup information (date)
* Show the content of a backup
* Restore a full backup

### Nice to have

* Find a file through all backup versions
* Restore a single file
* List/restore what is saved on the server

## Installation

### Requiremnents

* duplicity
* python-paramiko (for ssh backup)

### Steps

* Install yabs
* Generate a GPG key (or use an existing one)
* Add the config file
* Make sure duplicity can connect through ssh (if needed)

## TODO

* Manage errors when duplicity command fails


https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu
