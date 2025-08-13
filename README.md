# Homelab

## Overview
This repository contains all the configuration management code and scripts required to build my entire
homelab. The goal is to declaratively model as much of the lab as possible, and have automation
to fill in the gaps. Ideally, this lab can be fully built on any provider in minutes, whether it be in
the cloud, or in a local datacenter.

## Infrastructure
This lab is hardware platform agnostic. This may be AWS EC2 VMs, Promox QEMU VMs, or anything else.
| Hostname | IP Address | Service | OS |
|----------|------------|---------|----|
| TBD  | 10.10.1.x | Foo Bar | TBD |

*Proxmox homelab all runs on the flat 192.168.1.0/24 network.*

### Networking

**Kubernetes**
- 1.2.3.4/24 - Pod CIDR
- 2.3.4.5/24 - Service CIDR
- ...

**Proxmox**
- TBD

**AWS**
- TBD

**Tailscale**
- TBD


## Services
### Core
- Tailscale
- Kubernetes

### Applications
- Development Box
- Jellyfin
- OTEL + Prometheus + Grafana stack
- Game Server(s)
- Active Directory

## Usage

*TBD*
