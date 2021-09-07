
#----------------------------------------------------------------
##### CREATE VPC  ######################
#---------------------------------------------------------------

resource "aws_vpc" "My_VPC" {
  cidr_block           = var.VpcCIDRBlock         #"10.0.0.0/16"
  instance_tenancy     = var.VpcInstanceTenancy   #"default"
  enable_dns_support   = var.VpcDnsSupport        # "enable"
  enable_dns_hostnames = var.VpcEnableDnsHostname #"enable"

  tags = {
    Name = "My_VPC"
  }
}


#----------------------------------------------------------------
##### CREATE Subnet A ######################
#---------------------------------------------------------------

resource "aws_subnet" "My_VPC_Subnet_A" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.VpcSubnetCIDR_A # "10.0.1.0/24"
  map_public_ip_on_launch = var.mapPublicIP     #  "true"
  availability_zone       = var.AvlZone_A

  tags = {
    Name = "My_VPC_Subnet_A"
  }
}


#----------------------------------------------------------------
##### CREATE Subnet B ######################
#---------------------------------------------------------------

resource "aws_subnet" "My_VPC_Subnet_B" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.VpcSubnetCIDR_B # "10.0.2.0/24"
  map_public_ip_on_launch = var.mapPublicIP     #  "true"
  availability_zone       = var.AvlZone_B

  tags = {
    Name = "My_VPC_Subnet_B"
  }
}



#----------------------------------------------------------------
##### CREATE Subnet C ######################
#---------------------------------------------------------------

resource "aws_subnet" "My_VPC_Subnet_C" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.VpcSubnetCIDR_C # "10.0.3.0/24"
  map_public_ip_on_launch = var.mapPublicIP     #  "true"
  availability_zone       = var.AvlZone_C

  tags = {
    Name = "My_VPC_Subnet_C"
  }
}




#----------------------------------------------------------------
##### CREATE Security Group ######################
#---------------------------------------------------------------

resource "aws_security_group" "My_VPC_Secuity_Group" {
  name        = "My VPC Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.My_VPC.id

  # allow ingress of port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingressCIDRblock
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingressCIDRblock
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  }


  tags = {
    Name        = "My_VPC_Secuity_Group"
    Description = "My_VPC_Secuity_Group"
  }
}


#----------------------------------------------------------------
##### CREATE Internet Gateway ######################
#---------------------------------------------------------------


resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id

  tags = {
    Name = "My VPC Internet Gateway"
  }
}



#----------------------------------------------------------------
##### CREATE Route Table ######################
#---------------------------------------------------------------


resource "aws_route_table" "My_VPC_Route_Table" {
  vpc_id = aws_vpc.My_VPC.id

  tags = {
    Name = "My VPC Route Table"
  }
}

#----------------------------------------------------------------
##### CREATE Internet Access ######################
#---------------------------------------------------------------


resource "aws_route" "My_VPC_Internet_Access" {
  route_table_id         = aws_route_table.My_VPC_Route_Table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}


#----------------------------------------------------------------
##### Associate Route table with subnet ######################
#---------------------------------------------------------------

resource "aws_route_table_association" "My_VPC_Association_A" {
  subnet_id      = aws_subnet.My_VPC_Subnet_A.id
  route_table_id = aws_route_table.My_VPC_Route_Table.id
}


resource "aws_route_table_association" "My_VPC_Association_B" {
  subnet_id      = aws_subnet.My_VPC_Subnet_B.id
  route_table_id = aws_route_table.My_VPC_Route_Table.id
}


resource "aws_route_table_association" "My_VPC_Association_C" {
  subnet_id      = aws_subnet.My_VPC_Subnet_C.id
  route_table_id = aws_route_table.My_VPC_Route_Table.id
}





#----------------------------------------------------------------
#    Create IAM role  
#---------------------------------------------------------------
/*
resource "aws_iam_role" "ec2_ssm_access_role" {
  name               = "ec2_ssm_access_role"
  assume_role_policy = file("assumerolepolicy.json")
}
*/


#-----------------------------------------------------------------------------
#    Create IAM policy for ssm access(using policy.json) and attach it to Role
#------------------------------------------------------------------------------


/*
resource "aws_iam_role_policy" "ec2_policy" {
  name   = "ec2_policy"
  policy = file("policy.json")
  role   = aws_iam_role.ec2_ssm_access_role.id
}
*/
#----------------------------------------------------------------------------------------------
#    Create IAM Instance profile using IAM role and it is must to attach while creating instance.
#------------------------------------------------------------------------------------------------

/*
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_ssm_access_role.name
}
*/

#----------------------------------------------------------------------------------
#    Create EC2 Instance - Webserver (with user data script to install tomcat server) and attach role to it using instance profile
#----------------------------------------------------------------------------------

resource "aws_instance" "webserver" {
  ami                    = var.ami
  instance_type          = var.instance_type #"t2.micro"
  key_name               = var.key
  subnet_id              = aws_subnet.My_VPC_Subnet_A.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Secuity_Group.id]
  user_data              = file("script.sh")
  tags = {
    Name = "webserver"
  }
  iam_instance_profile = "ec2-role-from-console"                  #to attach role
}


output "public_ip" {
  value       = aws_instance.webserver.public_ip
  description = "The Public IP of webserver"
}
