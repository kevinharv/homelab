output "jellyfin_root_password" {
  value     = random_password.jellyfin_root_password.result
  sensitive = true
}
