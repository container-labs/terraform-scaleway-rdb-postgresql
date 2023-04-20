locals {
  username = "root"
}

resource "random_password" "root_user_password" {
  length      = 10
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

resource "scaleway_rdb_instance" "main" {
  name                      = var.name
  tags                      = [for k, v in var.tags : "${k}::${v}"]
  node_type                 = var.node_type
  engine                    = var.postgres_version
  is_ha_cluster             = var.cluster_mode == "highly-available" ? true : false
  user_name                 = local.username
  password                  = random_password.root_user_password.result
  region                    = var.region
  disable_backup            = var.backups.enabled ? false : true
  backup_schedule_frequency = var.backups.enabled ? var.backups.frequency_days : null
  backup_schedule_retention = var.backups.enabled ? var.backups.retention_days : null

  # The Managed Database product is only compliant with the private network in the default
  # availability zone (AZ). i.e. fr-par-1, nl-ams-1, pl-waw-1. To learn more,
  # read our section How to connect a PostgreSQL and MySQL Database Instance to a Private Network
  private_network {
    ip_net = "192.168.1.254/24" #pool high
    pn_id  = var.private_network_id
  }
}
