variable "keypair_name" {
  type = string
  description = "AWS SSH Key Pair name"
}

variable "keypair_path" {
  type = string
  description = "Full path and name for your private SSH key (*.pem file), example: ~/Documents/my_priv_key.pem"
}
