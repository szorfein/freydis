# Freydis

<p align="center">

![Gem](https://img.shields.io/gem/v/freydis?color=red&label=gem%20version&logo=ruby)
![Gem](https://img.shields.io/gem/dt/freydis?color=blue)
![GitHub](https://img.shields.io/github/license/szorfein/freydis)

</p>

Backup and restore data on encrypted device.

## Requirements
Freydis use `rsync` and `cryptsetup`.

## Install freydis locally

    $ gem install --user-install freydis

## Usage

    $ freydis -h

#### 0x01 - Initialisation
First, you need a config file and a disk encrypted.

    $ freydis --disk sdc --encrypt --save

The config file will be created at `~/.config/freydis/freydis.yaml`.

```yaml
---
:disk: /dev/disk/by-id/usb-SABRENT_SABRENT_DB9876543214E-0:0
:paths: []
```

+ disk: save the full path `by-id` for `sdc` here.
+ paths -> An Array which contain a list of absolute paths for backup.

#### 0x02 - First backup
Freydis will use `rsync`, all paths must be separated by a comma:

    $ freydis --backup --paths-add "/home,/etc" --save

#### 0x03 - Restore
With `--disk` and `--paths-add` saved in the config file, you only need to write:

    $ freydis --restore

Freydis will restore all files in `/`.

#### 0x04 - Secrets
Freydis can store secrets ([GPG Key](https://www.gnupg.org/) and [pass](https://www.passwordstore.org/) directory for now) and restore them if need:

    $ freydis --gpg-recipient szorfein@protonmail.com --secrets-backup
    $ freydis --gpg-recipient szorfein@protonmail.com --secrets-restore

The option `--secrets-restore` use `gpg --import` if the key is no found on your system.

### Tips
If you lost the config file, `freydis` has made a copy on your device when you're done your first `--backup`:

    $ freydis --open --disk sdc
    $ cp -a /mnt/freydis/home/user/.config/freydis ~/.config/

And you can use `freydis` normally.
