# Simple map of subnet configurations
variable "subnets" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
  default = {
    "web"  = "10.0.1.0/24"
    "app"  = "10.0.2.0/24"
    "data" = "10.0.3.0/24"
    "mgmt" = "10.0.4.0/24"

  }
}

variable "location" {
  description = "Locations"
  type        = string
  default     = "NorthEurope"
}

variable "environment" {
  description = ""
  type        = string
  default     = "dev"
}