output "id" {
  value = scaleway_rdb_instance.main.id
}

output "username" {
  value = local.username
}

output "password" {
  value = random_password.root_user_password.result
}

output "hostname" {
  value = scaleway_rdb_instance.main.private_network[0].hostname
}

output "port" {
  value = scaleway_rdb_instance.main.private_network[0].port
}
