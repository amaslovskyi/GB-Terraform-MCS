# terraform {
#   required_providers {
#     vkcs = {
#       source = "vk-cs/vkcs"
#     }
#   }
# }

# provider "vkcs" {
#   username   = "var.user_name"
#   password   = "var.passwd"
#   project_id = "var.id"
#   region     = "var.region"
#   auth_url   = "https://infra.mail.ru:35357/v3/"
# }

terraform {
  required_providers {
    vkcs = {
      source  = "vk-cs/vkcs"
      version = "~> 0.1.12"
    }
  }
}

provider "vkcs" {
  # Your user account.
  username = var.username

  # The password of the account
  password = var.passwd

  # The tenant token can be taken from the project Settings tab - > API keys.
  # Project ID will be our token.
  project_id = var.id
  # Region name
  region = var.region

  auth_url = "https://infra.mail.ru:35357/v3/"
}
