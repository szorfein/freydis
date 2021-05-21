* Customize errors message.
* Populate data with uuid, partuuid only after encrypting the disk.
* Control args `-d | --disk DISK`
* Control device with `cryptsetup isLuks` before proceed
* Enhance logic code for `bin/freydis`

## 0.0.2, release 2021/05/18
* New options `--open` and `--close`.
* Encrypt/Decrypt with `cryptsetup`.
* Add Rsync for backup and restore.
* Can add/remove paths with the `--cli`.
* Can (u)mount the encrypted device at the default `/mnt/freydis`.
* Checking all ID (partuuid, uuid, id) from a given device.
* YAML config file in ~/.config/freydis/freydis.yaml.

## 0.0.1, release 2021/05/04
* Initial push, code freeying !

