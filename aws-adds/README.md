# AWS Microsoft Active Directory Domain Controller Deployment

## Objectives

- immutable infrastructure - no patching, only redeploy
- fully-automated DC promo/demo
- load balancers for LDAP services, DNS, etc.
- DNS integration with Route53
- observability via CloudWatch? Dashboards in Grafana?
- blue/green deployment for upgrades

## High Level Procedure

1. Create foundational infrastructure (VPCs, NLB, R53, etc.)
1. Create VMs (blue or green)
1. DC promo, tag each VM as [ready, promoted, expired, retired] or something like that
1. Updating tags in TF triggers SSM automations to promote/demote the DC
1. When healthy, add VM to load balancing pool
1. When set to retire, remove from LB pool
1. Demote the DC
1. De-activate the blue/green or update the AMI

- to disable silo, set active=false in TF, which controls tags and downstream automation
	- maybe have power-state=false too to shut down the silo when not in use?
	- could have a Lambda do this too, but then TF isn't managing the infra.

