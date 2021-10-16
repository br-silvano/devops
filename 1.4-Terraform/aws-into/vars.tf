variable "amis" {
  type = map
  default = {
    "us-east-1" = "ami-00d1ab6b335f217cf"
    "us-east-2" = "ami-08e6b682a466887dd"
  }
}

variable "cdirs_acesso_remoto" {
  type = list
  default = [
    "128.201.142.27/32",
    "192.201.142.27/32"
  ]
}

variable "key_name" {
  type = string
  default = "terraform-aws"
}
