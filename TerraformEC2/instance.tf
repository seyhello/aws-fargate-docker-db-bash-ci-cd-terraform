provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "frontend" {
  ami             = "ami-03818140b4ac9ae2b"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sghirevolgy.name}"]
  key_name        = var.keypair_name

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.keypair_path)}"
      host        = self.public_ip
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install git",
      "sudo apt-get -y install docker.io",
      "mkdir Project",
      "cd Project",
      "sudo groupadd docker",
      "sudo gpasswd -a $USER docker",
      "git clone https://github.com/seyhello/aws-fargate-docker-db-bash-ci-cd-terraform.git",
      "cd revolgy-task/TerraformEC2/app-front/",
      "sudo docker build -t app-front .",
      "sudo docker run -p 8080:80 -d app-front"
    ]

  }

  tags = {
    Name = "HiRevolgy"
  }


}
