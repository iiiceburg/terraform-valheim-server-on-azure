variable "resource_group_name" {
  type        = string
  default     = "valheim-server"
  description = "Name of the resource group to create."
}

variable "resource_group_location" {
  type        = string
  default     = "southeastasia"
  description = "Location for all resources."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random value so name is unique in your Azure subscription."
}

variable "container_group_name_prefix" {
  type        = string
  description = "Prefix of the container group name that's combined with a random value so name is unique in your Azure subscription."
  default     = "valheim-group"
}

variable "container_name_prefix" {
  type        = string
  description = "Prefix of the container name that's combined with a random value so name is unique in your Azure subscription."
  default     = "vhl"
}

variable "image" {
  type        = string
  description = "Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials."
  default     = "lloesche/valheim-server:latest"
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 80
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 4
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 16
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "backup_path" {
  type        = string
  description = "The path to the backup folder in the container."
  default     = "/home/linuxgsm/valheimgameserverbackup"
}

variable "server_name" {
  type        = string
  description = "The name of the server."
  default     = "APE Serve"
}

variable "world_name" {
  type        = string
  description = "The name of the world."
  default     = "APEWORLD"
}

variable "server_pass" {
  type        = string
  description = "The password of the server."
  default     = "apegay"
}

variable "server_public" {
  type        = bool
  description = "Whether the server is public or not."
  default     = false
}

variable "supervisor_http" {
  type = bool
  description = "Whether to enable supervisor http or not."
  default = true
}

variable "supervisor_http_port" {
  type = number
  description = "The port of the supervisor http."
  default = 9001
}

variable "supervisor_http_username" {
  type = string
  description = "The username of the supervisor http."
  default = "admin"
}

variable "supervisor_http_password" {
  type = string
  description = "The password of the supervisor http."
  default = "admin"
}

variable "storage_share" {
  type = string
  description = "The name of the storage share."
  default = "valheim-server-data"
}

