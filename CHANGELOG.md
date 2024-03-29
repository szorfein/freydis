## 0.2.0, release 2023/10/23
* Define constant OPTIONS and ACTIONS
* Correct rsync options
* Can save gpg recipient in freydis.yaml
* Enhance output of freydis -L
* Move engine in Freydis::Main

## 0.1.1, release 2022/10/8
* Restore archive with sudo if permission are insufficient.

## 0.1.0, release 2022/09/20
* New dependencies for `Freydis::Secrets`: `bsdtar`, `shred` and `gnupg`.
* Option store a new field `gpg_recipient`.
* Can store and resttore GPG keys and matching directory of the [pass](https://www.passwordstore.org/) utility.
* Use only `/dev/disk/by-id` in the config file, the value does not change from one system to another.
* Rewrite code.

## 0.0.3, release 2021/07/04
* Add an option to `rsync` -R | --relative.
* Simplify config file, use only disk: [sdX].
* New option `--path-add`, `--path-del`, `--path-list`, `--save`.
* Adding basic test with minitest.
* Customize errors message.
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

