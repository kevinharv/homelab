# Install with Helm
helm upgrade --install authentik authentik/authentik -f values.yaml

# Generate recovery token for first time login
kubectl exec -it deployment/authentik-worker -c worker -- ak create_recovery_key 10 akadmin
