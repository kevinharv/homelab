# Infrastructure Deployment Terraform

## Information
### OpenEBS
Replicated storage is currently disabled. The host firewalls are not currently configured to support replication, and with a single control plane node and a single worker node, there is little use in replicated storage. Should the cluster be expanded, enabling replicated storage becomes a priority.

## To-Do
- Kubernetes nodes on Proxmox
    - Invoke Ansible for provisioning?
- Core Kubernetes cluster resources
    - NGINX Ingress (maybe drop in favor of only Gateway?)
    - Envoy Gateway
    - OpenEBS
    - Flannel (maybe upgrade to Cilium?)
    - MetalLB if network is upgraded to support
- Cloudflared or TailScale node for remote access
- PostgreSQL Host