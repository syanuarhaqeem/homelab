# Bootstrap

Prepare the bare metal `serveraku` before running Ansible.

| Item | Description |
|---|---|
| Debian version | `13.x` |
| Last tested | 11 November 2026 |

## 1. Install Debian

1. Download the latest Debian ISO from www.debian.org and write to a USB pendrive.
2. Boot from USB & install Debian.
3. Installer choices:

| Item | Description |
|---|---|
| Target disk | 240GB SSD |
| Filesystem | ext4 |
| Hostname, domain | `serveraku`, `home.arpa` |
| Static IP, gateway, DNS | `192.168.100.200/24`, `192.168.100.1`, `192.168.100.1` |
| Root login | disabled |
| Software | SSH server, standard |

## 2. Prepare the HDD storage

***Destructive!*** Skip on rebuild with data on HDD.

On `serveraku`, install parted package:

````bash
sudo apt install parted
````

Then, partition and format:

````bash
lsblk -f # identify disk. e.g. /dev/sdb

# destructive commands below
sudo parted /dev/sdb mklabel gpt
sudo parted /dev/sdb mkpart storage ext4 0% 100%
sudo mkfs.ext4 -L storage /dev/sdb1
````

## 3. SSH access from `workstation`

On `workstation`:

For rebuilds, reset:

````bash
ssh-keygen -R 192.168.100.200
````

Copy SSH key into `serveraku` and test.

````bash
ssh-copy-id -i ~/.ssh/workstation serveraku
ssh serveraku
````