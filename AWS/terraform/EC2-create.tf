
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  count         = 3
  root_block_device {
    volume_size = 30
  }
  key_name = "devops"
  user_data              = <<-EOF
              #!/bin/bash
              sudo curl https://releases.rancher.com/install-docker/19.03.sh | sh
              sudo usermod -aG docker ubuntu
              EOF
  tags = {
    Name = "K8s-${count.index}"
  }
 vpc_security_group_ids = ["devops"] 

}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  count         = 1
  root_block_device {
    volume_size = 30
  }
  key_name = "devops"
  user_data              = <<-EOF
              #!/bin/bash
              sudo curl https://releases.rancher.com/install-docker/19.03.sh | sh
              sudo usermod -aG docker ubuntu
              EOF
  tags = {
    Name = "Rancher"
  }
 vpc_security_group_ids = ["devops"] 

}