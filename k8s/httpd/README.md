# Scalable Apache (httpd) with Kubernetes
*Enterprise ready Apache webserver environment complete with LDAP authentication and WebDAV support. (soon TM)*

# To-Do
1. Get WebDAV with LDAP auth working
1. Migrate to K8s and test DAV locking
    - manage volume and permissions for lock
    - manage volume and permissions for content
1. Add SAML SSO via Shibboleth module?

## K8s Notes (theory)
- dav.svc.xyz:443 -> 444? (some other port) to allow separate VirtualHost for WebDAV
- all other 443 traffic can terminate normally (at Gateway, allow 80 into httpd)
    - TLS on K8s gateway allows us to remove SSL config from Apache (use for DAV specific traffic?)

- dav.httpd.svc.cluster.local:443 -> TLS terminate @ Gateway -> VirtualHost:443 for WebDAV ONLY
    - I think this is possible - may have to find another way to differentiate traffic
    - Would like to avoid putting WebDAV on anything other than 443
    - Needs to be separate from normal traffic due to httpd-2.4 issues with WebDAV and indexing
- httpd.svc.cluster.local:80 -> httpd.svc.cluster.local:443
- httpd.svc.cluster.local:443 -> TLS terminate @ Gateway -> VirtualHost:80 for normal traffic

## Entrypoint Planning
- Create and set ownership/permissions on directories for DAV, logs, sites, etc.
- Copy configuration files from mounted config directory (volume on Docker, ConfigMap volume on K8s)