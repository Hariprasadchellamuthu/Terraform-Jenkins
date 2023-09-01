provider "aws" {
    region = "us-east-1"  

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
  bucket = bucket_n00
  acl    = "private"
}
