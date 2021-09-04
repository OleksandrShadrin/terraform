provider "aws" {
  access_key = "AKIAXNO3XY2Z2DGGVH7Z"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.My_Ubuntu.id]
  user_data              = <<-EOF
    #! /bin/bash
    yum -y update
    yum -y install apache2
    myip = "curl http://169.254.169.254/latest/meta-data/local-ipv4"
    echo "<h2>WebServer with IP: $myip</h2><br> Build by Terraform!" > /var/www/html/index.html
    sudo service httpd start
    chkconfig httpd on
    EOF
  tags = {
    Name = "terraform-webserver"
  }
}

resource "aws_security_group" "My_Ubuntu" {
  name = "Webserver_Security_Group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
