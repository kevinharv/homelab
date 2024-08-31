# Infrastructure Deployment Terraform

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