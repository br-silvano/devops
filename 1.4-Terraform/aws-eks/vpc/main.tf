data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-${var.environment}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
  }
}

resource "aws_subnet" "public" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, var.availability_zones_count + count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true
  depends_on = [aws_vpc.main]

  tags = {
    Name = "node-group-subnet-${count.index + 1}-${var.environment}"
    state = "public"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  depends_on = [aws_vpc.main]

  tags = {
    "Name" = "fargate-subnet-${count.index + 1}-${var.environment}"
    "state" = "private"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  depends_on = [aws_vpc.main]

  tags = {
    Name = "eks-internet-gateway-${var.environment}"
  }
}

resource "aws_eip" "nat" {
  count = var.availability_zones_count
  vpc = true
  public_ipv4_pool = "amazon"
}

resource "aws_nat_gateway" "gateway" {
  count = var.availability_zones_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  depends_on = [aws_subnet.public]

  tags = {
    Name = "eks-nat_gateway-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "${var.cidr_block-internet_gateway}"
    gateway_id = aws_internet_gateway.gateway.id
  }
  depends_on = [aws_internet_gateway.gateway]

  tags  = {
    Name = "eks-public_route_table-${var.environment}"
    state = "public"
  }
}

resource "aws_route_table" "nat-route" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "${var.cidr_block-nat_gateway}"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  depends_on = [aws_nat_gateway.gateway]

  tags  = {
    Name = "eks-nat_route_table-${count.index + 1}-${var.environment}"
    state = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = var.availability_zones_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.internet-route.id
}

resource "aws_route_table_association" "private" {
  count = var.availability_zones_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.nat-route.*.id, count.index)
}
