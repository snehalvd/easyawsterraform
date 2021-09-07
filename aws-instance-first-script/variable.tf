# variable.tf 

variable "region" {
  default = "us-west-2"
}


variable "AvlZone_A" {
  default = "us-west-2a"
}

variable "AvlZone_B" {
  default = "us-west-2b"
}

variable "AvlZone_C" {
  default = "us-west-2c"
}

variable "key" {
  default = "MyOregonKey10-July"
}

variable "ami" {
  default = "ami-083ac7c7ecf9bb9b0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "VpcInstanceTenancy" {
  default = "default"
}

variable "VpcCIDRBlock" {
  default = "10.0.0.0/16"
}

variable "VpcDnsSupport" {
  default = true
}

variable "VpcEnableDnsHostname" {
  default = true
}

variable "VpcSubnetCIDR_A" {
  default = "10.0.1.0/24"
}

variable "VpcSubnetCIDR_B" {
  default = "10.0.2.0/24"
}

variable "VpcSubnetCIDR_C" {
  default = "10.0.3.0/24"
}

variable "mapPublicIP" {
  default = true
}

variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}










