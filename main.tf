provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_frontdoor" "fd" {
  name                = var.frontdoor_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  routing_rule {
    name               = var.routing_rule_name
    frontend_endpoints = [azurerm_frontdoor_fd.endpoint.name]
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    route_configuration {
      forwarding_configuration {
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = azurerm_frontdoor_backend_pool.backend_pool.name
      }
    }
  }

  backend_pool {
    name = var.backend_pool_name

    backend {
      host_header = var.backend_host_header
      address     = var.backend_address
      http_port   = 80
      https_port  = 443
      enabled     = true
    }
    load_balancing_name  = azurerm_frontdoor_load_balancing.lb.name
    health_probe_name    = azurerm_frontdoor_health_probe.hp.name
  }
}

resource "azurerm_frontdoor_backend_pool" "backend_pool" {
  name                = var.backend_pool_name
  resource_group_name = azurerm_resource_group.rg.name
  frontend_endpoints  = [azurerm_frontdoor_fd.endpoint.name]
  load_balancing_name = azurerm_frontdoor_load_balancing.lb.name
  health_probe_name   = azurerm_frontdoor_health_probe.hp.name
}

resource "azurerm_frontdoor_health_probe" "hp" {
  name                = var.health_probe_name
  resource_group_name = azurerm_resource_group.rg.name
  protocol            = "Https"
  path                = "/"
  interval_in_seconds = 30
}

resource "azurerm_frontdoor_load_balancing" "lb" {
  name                = var.load_balancing_name
  resource_group_name = azurerm_resource_group.rg.name
  additional_latency_milliseconds = 0
}

output "frontdoor_endpoint" {
  value = azurerm_frontdoor_fd.endpoint.name
}
