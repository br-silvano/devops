variable "secret_id" {
  description = "put your secret name here"
}

variable "identifier" {
  description = "enter the name of our database which is unique in that region"
}

variable "allocated_storage" {
  description = "enter the storage of database"
}

variable "storage_type" {
  description = "put the type of storage you want"
}

variable "engine" {
  description = "put your database engine you want eg. mysql"
}

variable "engine_version" {
  description = "which version you want of your db engine"
}

variable "instance_class" {
  description = "which type of instance you need like ram and cpu  eg. db.t2.micro"
}

variable "database_name" {
  description = "enter your initial database name"
}

variable "environment" {
  description = "your environment name"
}

variable "private_subnets" {
  description = "list of private subnet IDs"
}

variable "vpc_id" {
  description = "put your vpc id"
}
