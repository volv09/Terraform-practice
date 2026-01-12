
# ========================
# VPC
# ========================
module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  tags     = { Name = "${var.environment}-vpc" }

  public_subnets = [
    { cidr_block = "10.0.1.0/24", az = "eu-west-1a" },
    { cidr_block = "10.0.3.0/24", az = "eu-west-1b" }
  ]

  private_subnets = [
    { cidr_block = "10.0.2.0/24", az = "eu-west-1a" },
    { cidr_block = "10.0.4.0/24", az = "eu-west-1b" }
  ]
}

# ========================
# Security Group
# ========================
module "sg" {
  source  = "../../modules/vpc/sg"
  vpc_id  = module.vpc.vpc_id
  sg_name = "${var.sg-name}-sg"
  tags    = { Name = "${var.sg-name}-sg" }
}

# ========================
# Security Group Rules
# ========================
module "sg_rules" {
  source            = "../../modules/vpc/sg-rules"
  security_group_id = module.sg.sg_id

  ingress_rules = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]

  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

# ========================
# EC2 Instances
# ========================
module "ec2_public" {
  source        = "../../modules/ec2"
  instance_name = "ec2-public-1"
  ami_id        = ""
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  sg_ids        = [module.sg.sg_id]
}

module "ec2_private" {
  source        = "../../modules/ec2"
  instance_name = "ec2-private-1"
  ami_id           = ""
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet_ids[0]
  sg_ids        = [module.sg.sg_id]
}
