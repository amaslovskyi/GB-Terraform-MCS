# credentials
variable "username" {
  type        = string
  default     = ""
  description = "login"
}

variable "passwd" {
  type        = string
  default     = ""
  description = "pass"
}

variable "id" {
  type        = string
  default     = "45566b30a56b4896999bec0b7941dfd2"
  description = "Project id"
}

variable "region" {
  type        = string
  default     = "RegionOne"
  description = "Region"
}
# networx
variable "ext-net" {
  type        = string
  description = ""
  default     = "ext-net"
}

variable "net" {
  type        = string
  description = ""
  default     = "compute-net"
}

variable "cidr" {
  type        = string
  description = ""
  default     = "192.168.10.0/24"
}

variable "admin" {
  type        = string
  description = "admin access"
  default     = "133.158.125.207/32"
}

# Compute instance

variable "ci-name1" {
  type        = string
  description = ""
  default     = "webhost1"
}

variable "ci-name2" {
  type        = string
  description = ""
  default     = "webhost2"
}
