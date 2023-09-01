provider "aws" {
    region = "us-east-1"  
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "bucket_name" {
  type    = string
  default = "my-terraform-bucket"
}

# EC2 Instance
resource "aws_instance" "foo" {
  ami           = "ami-05fa00d4c63e32376" # us-east-1
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}
