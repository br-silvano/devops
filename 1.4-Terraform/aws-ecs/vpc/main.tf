data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

resource "aws_subnet" "public" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.default.id
  cidr_block = cidrsubnet(aws_vpc.default.cidr_block, 8, var.availability_zones_count + count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true
  depends_on = [aws_vpc.default]

  tags = {
    Name = "ecs-public-subnet-${count.index + 1}-${var.environment}"
    state = "public"
  }
}

resource "aws_subnet" "private" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.default.id
  cidr_block = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  depends_on = [aws_vpc.default]

  tags = {
    "Name" = "ecs-private-subnet-${count.index + 1}-${var.environment}"
    "state" = "private"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id
  depends_on = [aws_vpc.default]

  tags = {
    Name = "ecs-internet-gateway-${var.environment}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.default.main_route_table_id
  destination_cidr_block = "${var.cidr_block-internet_gateway}"
  gateway_id = aws_internet_gateway.gateway.id
}

resource "aws_eip" "nat" {
  count = var.availability_zones_count
  vpc = true
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "gateway" {
  count = var.availability_zones_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)

  tags = {
    Name = "ecs-fargate-nat_gateway-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route_table" "private" {
  count = var.availability_zones_count
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "${var.cidr_block-nat_gateway}"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  depends_on = [aws_vpc.default]

  tags  = {
    Name = "ecs-fargate-nat_route_table-${count.index + 1}-${var.environment}"
    state = "private"
  }
}

resource "aws_route_table_association" "private" {
  count = var.availability_zones_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
