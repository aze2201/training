provider "null" {}


resource "null_resource" "bash_dummy" {

  connection {
    type           = "ssh"
    user           = "root"
    host           = "XXXX"
    private_key    = var.ssh_root_private_key
  }

  provisioner "remote-exec" {
    inline = [
       "touch /root/abc_k_root"
    ]
  }
}

resource "null_resource" "install_k8s" {

  connection {
    type           = "ssh"
    user           = "root"
    host           = var.ssh_host
    private_key    = var.ssh_root_private_key
  }
  
  provisioner "file" {
    source = "${path.module}/setup_k8s_single.sh"
    destination = "/tmp/setup_k8s_single.sh" 
  }  

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_k8s_single.sh",
      "export POD_NETWORK_CIDR=${var.pod_network_cidr} && /tmp/setup_k8s_single.sh"
    ]
  }
}

output "k8s_host" {
  value = var.ssh_host
}
