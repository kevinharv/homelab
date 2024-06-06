# Scalable Apache (httpd) with Kubernetes
*Enterprise ready Apache webserver environment complete with LDAP authentication and WebDAV support. (soon TM)*

# To-Do
1. Get basic WebDAV working
    - Alpine doesn't support dependencies required for lock file?
    - DBM driver cannot be loaded
1. Get WebDAV with LDAP auth working
1. Migrate to K8s and test DAV locking
1. Add SAML SSO via Shibboleth module?