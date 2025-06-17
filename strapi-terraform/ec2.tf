# SSH key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/deployer-key.pub")

}

# Security group allowing SSH and Strapi access
resource "aws_security_group" "strapi_sg" {
  name        = "my_strapi_sg"
  description = "Allow SSH and Strapi access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

# EC2 instance
resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-01f5a0b78d6089704" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.key_name

  user_data = file("user-data.sh")

  tags = {
    Name = "StrapiEC2"
  }
}

