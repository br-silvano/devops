cluster_name                  = "demo"
environment                   = "production"
vpc_cidr                      = "10.30.0.0/16"
vpc_name                      = "demo"
availability_zones_count      = 3
cidr_block-internet_gateway   = "0.0.0.0/0"
cidr_block-nat_gateway        = "0.0.0.0/0"

eks_node_group_instance_types = "t3.xlarge"
fargate_namespace             = "fargate-node"

/*
secret_id                     = "database"
identifier                    = "database"
allocated_storage             = 100
storage_type                  = "io1"
engine                        = "mysql"
engine_version                = 5.7
instance_class                = "db.m5.xlarge"
database_name                 = "db"
*/
