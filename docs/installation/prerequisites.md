# Prerequisites

Prerequisites to bootstrap `serveraku`.

---

## 1. Hardware

| Item | Description |
|---|---|
| Machine | HP ProDesk 400 G5 MT |
| CPU | Intel Core i5-8500 (6c6t), UHD Graphics 630 (Quick Sync) |
| RAM | DDR4 20GB 2666 MHz |
| SSD | 240GB |
| HDD | 2TB (`/mnt/storage`) |
| Network | Wired Ethernet |

### BIOS Settings

1. Integrated graphics: **enabled**
2. After power loss: **power on**

## 2. Network

| Item | Description |
|---|---|
| Subnet | 192.168.100.0/24 |
| Router/gateway/DNS | 192.168.100.1 |
| Router DHCP pool | 192.168.100.2 - 192.168.100.99 |
| `serveraku` | 192.168.100.200 |

### Names

Service URLs use a public domain so that trusted certificates can be obtained via the ACME DNS-01 challenge.

| Name | Description |
|---|---|
| `serveraku.home.arpa` | Hostname |
| `home.byanuar.com` | Service URLs |

## 3. Setup `workstation`

`workstation` is the machine where the development takes place.

It needs to be Linux, macOS or Windows via WSL for OpenTofu and Ansible. 

Instructions are written based on laptop running Fedora.

On `workstation`:

### Install prerequisite tools

Tools required on the laptop workstation.

````bash
sudo dnf upgrade --refresh
sudo dnf install git gh pipx age opentofu
````

`sops` is not in Fedora's repos. Install the `.x86_64.rpm` release file from [getsops/sops on GitHub](https://github.com/getsops/sops/releases).

````bash
sudo dnf install ~/Downloads/sops*.rpm
````

Install Ansible via pipx.

````bash
pipx ensurepath
````

Open a new terminal, then:

````bash
pipx install --include-deps ansible-core
````

### Verify

Verify that all prerequisite tools have been installed.

````bash
git --version
gh --version
tofu version
ansible --version
sops --version
age --version
````

### Clone the repository

````bash
gh auth login
gh repo clone syanuarhaqeem/homelab ~/Projects/homelab
cd ~/Projects/homelab/ansible
ansible-galaxy collection install -r requirements.yml
````

### SSH Key

The key will be copied to `serveraku` during bootstrap.

````bash
ssh-keygen -t ed25519 -f ~/.ssh/workstation -C "workstation"
````

Append to SSH config file.

````bash
cat >> ~/.ssh/config <<'EOF'
Host serveraku serveraku.home.arpa 192.168.100.200
    HostName 192.168.100.200
    User <username>
    IdentityFile ~/.ssh/workstation
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config
````

## 4. External services

List of free external services this homelab uses.

| Service | Description |
|---|---|
| GitHub | Repository |
| Tailscale | Remote access VPN |
| Cloudflare | DNS for `byanuar.com` for ACME DNS-01 challenge |

## Next

[Bootstrap](bootstrap.md)