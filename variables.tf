# credentials
variable "username" {
  type        = string
  default     = "fg.adminus@gmail.com"
  description = "login"
}

variable "passwd" {
  type        = string
  default     = "ctr%bU6jQmw*3C"
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
  default     = "135.157.124.200/32"
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
