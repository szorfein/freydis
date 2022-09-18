# Freydis
Backup and restore data on encrypted device.

## Requirements
Freydis use `rsync` and `cryptsetup`.

## Install freydis locally

    gem install freydis-0.0.1.gem -P HighSecurity

## Usage

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

### Tips
If you lost the config file, `freydis` has made a copy on your device when you're done your first `--backup`:

    $ freydis --open --disk sdc
    $ cp -a /mnt/freydis/home/user/.config/freydis ~/.config/

And you can use `freydis` normally.
