cluster_name                  = "demo"
environment                   = "test"
vpc_cidr                      = "10.33.0.0/16"
vpc_name                      = "demo"
availability_zones_count      = 2
cidr_block-internet_gateway   = "0.0.0.0/0"
cidr_block-nat_gateway        = "0.0.0.0/0"

eks_node_group_instance_types = "t2.micro"
fargate_namespace             = "fargate-node"

/*
secret_id                     = "database"
identifier                    = "database"
allocated_storage             = 20
storage_type                  = "gp2"
engine                        = "mysql"
engine_version                = 5.7
instance_class                = "db.t2.micro"
database_name                 = "db"
*/
