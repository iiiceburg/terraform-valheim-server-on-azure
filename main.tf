resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "storage_name" {
  length  = 12
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "$valheimstorage${random_string.storage_name.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  depends_on = [azurerm_resource_group.rg]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_share" "file_share" {
  name                 = "valheim-server-data"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
  depends_on           = [azurerm_storage_account.storage]
}

resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    environment_variables = {
      "SERVER_NAME"              = var.server_name,
      "WORLD_NAME"               = var.world_name,
      "SERVER_PASS"              = var.server_pass,
      "SERVER_PUBLIC"            = var.server_public,
      "SUPERVISOR_HTTP"          = var.supervisor_http,
      "SUPERVISOR_HTTP_PORT"     = var.supervisor_http_port,
      "SUPERVISOR_HTTP_USERNAME" = var.supervisor_http_username,
      "SUPERVISOR_HTTP_PASSWORD" = var.supervisor_http_password
    }

    ports {
      port     = "9001"
      protocol = "TCP"
    }

    ports {
      port     = "2456"
      protocol = "UDP"
    }

    ports {
      port     = "2457"
      protocol = "UDP"
    }

    volume {
      name       = "valheim-server-data"
      mount_path = var.backup_path

      storage_account_name = azurerm_storage_account.storage.name
      storage_account_key  = azurerm_storage_account.storage.primary_access_key
      share_name           = azurerm_storage_share.file_share.name
    }
  }

  depends_on = [azurerm_storage_account.storage, azurerm_storage_share.file_share]
}
