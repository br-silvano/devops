variable "cluster_name" {
  description = "name of cluster"
}

variable "environment" {
  description = "environment name"
}

variable "vpc_name" {
  description = "name of vpc"
}

variable "vpc_cidr" {
  description = "cidr value of vpc"
}

variable "availability_zones_count" {
  description = "availability zones"
}

variable "cidr_block-nat_gateway" {
  description = "destination cidr of nat gateway"
}

variable "cidr_block-internet_gateway" {
  description = "destination cidr of internet gateway"
}
