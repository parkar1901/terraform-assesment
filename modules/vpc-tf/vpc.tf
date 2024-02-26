# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

# ---------------- Create 2 public and 2 private subnets ----------------
# Create the public subnet-1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "${var.pub_subnet_1_cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

# Create the public subnet-2
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "${var.pub_subnet_2_cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

# Create the private subnet-1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "${var.pri_subnet_1_cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-1"
  }
}

# Create the private subnet-2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "${var.pri_subnet_2_cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-2"
  }
}

# --------- create IGW and attach to VPC ----------
# Create an internet gateway & attach it to the VPC 
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}





# ----------------- Create route table for public subnet  -----------------
# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

# Create a route in the public route table to the internet gateway
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

# Associate the public subnet-1 with the public route table
resource "aws_route_table_association" "public_subnet_association1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the public subnet-2 with the public route table
resource "aws_route_table_association" "public_subnet_association2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


# ----------------- Create route table for private subnet  -----------------
# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate the private subnet-1 with the private route table
resource "aws_route_table_association" "private_subnet_association1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate the private subnet-2 with the private route table
resource "aws_route_table_association" "private_subnet_association2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

/*
#---------------------------------------
# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

# Create the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false
}

# Enable VPC peering for future growth
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id        = aws_vpc.my_vpc.id
  peer_vpc_id   = aws_vpc.my_vpc.id
  peer_region   = "us-west-2"
  auto_accept   = true
}

# Add any additional resources or configurations for future growth and scale
*/

output "my_vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "my_Pub_Subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}
output "my_Pub_Subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}
output "my_Pri_Subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}
output "my_Pri_Subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}