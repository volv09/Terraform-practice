resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.tags["Name"]}-IGW" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { Name = "${var.tags["Name"]}-public-rt" }
}

resource "aws_subnet" "public" {
  for_each = { for i, s in var.public_subnets : i => s }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = { Name = "${var.tags["Name"]}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = { for i, s in var.private_subnets : i => s }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = { Name = "${var.tags["Name"]}-private-${each.key}" }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
