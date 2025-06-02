# Development Virtual Workstation

*I'm tired of having two computers, neither truly Linux. Time to remote into a development box.*

## Overview

Create Ubuntu 25.04 (for now) virtual development workstation with RDP enabled. Build from ISO with Packer against Proxmox. Provision with Terraform. Post-provisioning configuration and lifecycle management with Ansible. This might be a trial for dual booting or solely running Linux when Windows 10 goes EoL.

## Specification

### Hardware

- 4 vCPU
- 8GB RAM (for now)
- EFI
- TPM 2.0
- 64 GB disk space (this machine will be semi-ephermal so shouldn't persist much)

### Software

- Ubuntu 25.04 (for now)
- Gnome (for now)
- Configure SSH
    - Unique key for this one
    - No password auth
- Docker
- VS Code
- Chrome (probably switching back from Firefox)
- Git with dotfiles repo (revive)
- Maybe some other base repos cloned down
- Dev tooling
    - Go
    - JS/TS
    - Java
    - Python
    - AWS CLI
    - Ansible
    - Packer
    - Terraform
- Misc. software
    - Fastfetch (and customize it)

- RDP server (for Wayland)