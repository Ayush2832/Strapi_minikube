resource "aws_security_group" "nsg1" {
    vpc_id = aws_vpc.main.id
    name = var.nsg-name

    description = "Necessary inbound rules"

    ingress {
        description = "Strapi port"
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "SSH port"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "security-group"
    }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  # public_key = var.key-path
  public_key = file(var.key-path)
}

resource "aws_instance" "strapi_ec2" {
  ami                    = var.ami
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.nsg1.id]
  key_name               = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/command.sh")
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "strapi_vm"
  }
}