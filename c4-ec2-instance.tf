resource "aws_instance" "my-ec2-vm" {
  ami = data.aws_ami.amznlinux2.id
  #instance_type = var.instance_type
  #instance_type = var.instance_type_list[1] #for list
  key_name = "terraform-key"
  instance_type = var.instance_type
  #count = terraform.workspace == "default" ? 2:1
  user_data = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id,aws_security_group.vpc-web.id]
  
  tags = {
    "Name" = "vm-${terraform.workspace}-0"
  }

  #connection block for provisoner to connect to your ec2 instance 
  connection {
    type = "ssh"
    host = self.public_ip #understand hwat is self aws_instance.my-ec2-vm.*.public_ip
    #selc.publicip same aws_instance.public_ip
    user = "ec2-user"
    password = ""
    private_key = file("private-key/terraform-key.pem")
  }
  #now we can copy the file
  provisioner "file" {
    source = "app/file-copy.html" #local machine 
    destination = "/tmp/file-copy.html" #remote machine
  }
  provisioner "file" {
    content = "ami used: ${self.ami}" #gather the ami details
    destination = "/tmp/file.log" #store in this file. 
  }
  #copy the app1 folder to the /tmp folder
  provisioner "file" {
    source = "apps/app1" #local machine 
    destination = "/tmp" #remote machine
  }
#when you put "/" content of the folder will be copied. 
  provisioner "file" {
    source = "apps/app2/" #local machine 
    destination = "/tmp" #remote machine
  }
  
}

















