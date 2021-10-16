variable "cluster_name" {
  description = "the name of your stack, e.g. \"demo\""
  default = "demo"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default = "test"
}

variable "vpc" {
  description = "id of vpc"
}

variable "private_subnets" {
  description = "list of private subnet IDs"
}

variable "public_subnets" {
  description = "list of private subnet IDs"
}

variable "app_count" {
  description = "count of tasks in fargate service"
}
