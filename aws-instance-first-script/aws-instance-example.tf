resource "aws_instance" "web1" {
   ami           = "var.ami_id"
   instance_type = "t2.micro"
 }
