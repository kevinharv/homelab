# Homelab

## TODO/Ambitions
- Infrastructure-as-code wherever possible
- Fully automated deployment of all (non-host) systems and services

## Overview
This repository contains all the configuration management code and scripts required to build my entire
homelab. The goal is to declaratively model as much of the lab as possible, and have automation
to fill in the gaps. Ideally, this lab can be fully built on any provider in minutes, whether it be in
the cloud, or in a local datacenter.

## Infrastructure
This lab is hardware platform agnostic. This may be AWS EC2 VMs, Promox QEMU VMs, or anything else.
| Hostname | IP Address | Service | OS |
|----------|------------|---------|----|
| PRDBSTN  | 10.10.1.6 | Bastion/VPN | Rocky Linux 9.1 |
| PRDNAS1  | 10.10.1.7 | SMB/NFS | Rocky Linux 9.1 |
| PRDIPA1  | 10.10.1.5 | FreeIPA | Rocky Linux 9.1 |
| PRDKUB1  | 10.10.1.20 | Kubernetes | Rocky Linux 9.1 |
| PRDKUB2  | 10.10.1.21 | Kubernetes | Rocky Linux 9.1 |
| PRDKUB3  | 10.10.1.22 | Kubernetes | Rocky Linux 9.1 |

### Subnets
Management: 10.10.1.0/24
Kubernetes?: 10.10.5.0/24

## Services
### Core
- OpenVPN
- PiHole
- Kubernetes Cluster
- NGINX Proxy Manager
- NFS/SMB
- FreeIPA

### Application
- Linux Dev Box? Torrent box?
- Jellyfin
- NVR
    - Shinobi
    - Kerberos.io
    - Frigate
    - Bluecherry
- rsyslog? Loki?
- Grafana + Prometheus
- Game Server(s)
- Jenkins?

## Usage