# Freydis
Backup and restore data on encrypted device.

## Requirements
Freydis use `rsync` and `cryptsetup`.

## Gem build

    gem build freydis.gemspec

## Install freydis locally

    gem install freydis-0.0.1.gem -P HighSecurity

## Usage

#### 0x01 - Config file
First, you need a config file. You can use `freydis --init` or make one with your favorite editor.  
The config file should be placed at `~/.config/freydis/freydis.yaml`.

An example of final config:

```yaml
---
:disk: sdc
:disk_id: usb-SABRENT_SABRENT_DB9876543214E-0:0
:disk_uuid: 10f531df-51dc-x19e-9bd1-bbd6659f0c3f
:disk_partuuid: ''
:paths:
- "/home/daggoth/labs"
- "/home/daggoth/musics"
- "/home/daggoth/.password-store"
- "/home/daggoth/documents"
```

As you see:
+ disk: sdc -> Use only `sd[a-z]` without partition.
+ disk_id -> (Optionnal), freydis will find it if void.
+ disk_uuid -> (Optionnal)
+ disk_partuuid -> (Optionnal)
+ paths -> Contain a list of absolute paths on each line.

#### 0x02 - Encrypt the disk
Freydis will use `cryptsetup` with `luks2` and format the disk with `ext4`:

    $ freydis --encrypt

#### 0x03 - Other options
Make an incremental backup, will copy all `paths` include in the config file:

    $ freydis --backup

Restore files in your system `/`:

    $ freydis --restore

If you lost the config file, `freydis` has made a copy on your device when you're done your first `--backup`:

    $ freydis --open --disk sdc
    $ cp -a /mnt/freydis/home/user/.config/freydis ~/.config/

And you can use `freydis` normally.
