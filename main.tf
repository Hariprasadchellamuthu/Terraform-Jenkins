provider "aws" {
    region = "us-east-1"  
}

# Create AWS EC2
resource "aws_instance" "foo" {
  ami           = "ami-05fa00d4c63e32376" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}

# Create AWS S3
resource "aws_s3_bucket" "buck1" {
    bucket = "mybucket43""
    acl = "private"

    tags = {
        Name = "My bucket"
        Environment = "DevKJT"
    }
}
