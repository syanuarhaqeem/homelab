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

## 4. Configure Tailscale

On `workstation`:

1. Log into Tailscale UI

2. Access controls > JSON editor:

````json
"tagOwners": {
	"tag:homelab": ["autogroup:admin"],
},
````

3. Settings > Keys. Generate auth key. Tag with `homelab`, leave everything else on default. Copy the generated key.

4. From project root, run:

````bash
sops ansible/inventory/group_vars/all.sops.yml
````

Add/replace entry:

````yaml
tailscale_auth_key: AUTH_KEY
````

## 5. Update Ansible variables

On `workstation`:

Update the values in `ansible/inventory/hosts.yml`

| Variable | Where to get it |
|---|---|
| `storage_uuid` | `sudo blkid` on `serveraku` |
| `ansible_public_keys` | `cat ~/.ssh/workstation.pub` on `workstation` |

## 6. Run Ansible

On `workstation`:

````bash
cd ~/Projects/homelab/ansible
ansible-playbook playbooks/bootstrap.yml
ansible-playbook playbooks/site.yml
````

Enter the username for the user with sudo privileges and its password to bootstrap the ansible user.

From Tailscale UI > Network > Machines: under `serveraku`, approve the subnet route and optionally exit node (for proxying devices traffic through the same network as `serveraku`).