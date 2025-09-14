variable "ssh" {
  description = "MAIN 서버 SSH 접속 정보"
  type = object({
    host            = string
    user            = string
    public_key_path = string
  })
}
resource "null_resource" "init_setup" {
  connection {
    type        = "ssh"
    user        = var.ssh.user
    host        = var.ssh.host
    private_key = file(replace(var.ssh.public_key_path, ".pub", ""))
  }

  provisioner "file" {
    source      = var.ssh.public_key_path
    destination = "/tmp/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys",
      "chmod 700 ~/.ssh",
      "chmod 600 ~/.ssh/authorized_keys",
      "rm /tmp/id_rsa.pub",
    ]
  }
}

