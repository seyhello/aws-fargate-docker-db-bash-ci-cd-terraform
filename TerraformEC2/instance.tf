provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "frontend" {
  ami             = "ami-03818140b4ac9ae2b"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sghirevolgy.name}"]
  key_name        = "KeyPair"

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/kamil/Documents/TerraformEC2/KeyPair.pem")}"
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
      "git clone https://github.com/seyhello/revolgy-task.git",
      "cd revolgy-task/",
      "cd app-front/",
      "sudo docker build -t app-front .",
      "sudo docker run -p 8080:80 -d app-front"
    ]

  }

  tags = {
    Name = "HiRevolgy"
  }


}
