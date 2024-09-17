# Freydis

<div align="center">

[![Gem Version](https://badge.fury.io/rb/freydis.svg)](https://badge.fury.io/rb/freydis)
![Gem](https://img.shields.io/gem/dtv/freydis?color=red)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/szorfein/freydis/develop?color=blue)
![GitHub](https://img.shields.io/github/license/szorfein/freydis?color=cyan)

</div>

Backup and restore data (on encrypted) device.

## Requirements
Freydis use `rsync` and `cryptsetup` and optionnal `bsdtar`, `shred`, `gnupg`.

## Install freydis locally

    $ gem install --user-install freydis

## Usage

    $ freydis -h

## Examples

#### 0x01 - Initialisation
First, you need to configure freydis and optionnaly encrypt a device disk.

    $ freydis --disk /dev/sdc --encrypt --save

The config file will be created at `~/.config/freydis/freydis.yaml`.

```yaml
---
:disk: '/dev/sdc'
:disk_is_encrypt: true
:gpg_recipient: ''
:backup_paths: []
:exclude_paths: []
:restore_at: '/'
```

#### 0x02 - First backup
Freydis will use `rsync`, all paths must be separated by a comma:

    $ freydis --paths-add /home,/etc --save

You can also exclude some paths with `--paths-del`

    $ freydis --paths-del ~/.cache,~/.npm --save

And backup

    $ freydis --backup

#### 0x03 - Restore
With `--disk` and `--paths-add` saved in the config file, you only need to write:

    $ freydis --restore

Freydis will restore all files in `/` by default, use `--restore-at PATH` to change.

#### 0x04 - Secrets
Freydis can store secrets ([GPG Key](https://www.gnupg.org/) and [pass](https://www.passwordstore.org/) directory for now) and restore them if need:

    $ freydis --gpg-recipient szorfein@protonmail.com --secrets-backup
    $ freydis --gpg-recipient szorfein@protonmail.com --secrets-restore

The option `--secrets-restore` use `gpg --import` if the key is no found on your system.
