variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the resources"
  type        = string
  default     = "West Europe"
}

variable "frontdoor_name" {
  description = "The name of the Front Door instance"
  type        = string
}

variable "routing_rule_name" {
  description = "The name of the Front Door routing rule"
  type        = string
}

variable "backend_pool_name" {
  description = "The name of the Front Door backend pool"
  type        = string
}

variable "backend_host_header" {
  description = "The host header to be sent to the backend"
  type        = string
}

variable "backend_address" {
  description = "The address of the backend"
  type        = string
}

variable "health_probe_name" {
  description = "The name of the Front Door health probe"
  type        = string
}

variable "load_balancing_name" {
  description = "The name of the Front Door load balancing settings"
  type        = string
}

output "frontdoor_endpoint" {
  description = "The endpoint URL of the Front Door"
  value       = string
}
