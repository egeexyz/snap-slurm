variable "api_key" {
  type = string
}

provider "vultr" {
  api_key = var.api_key
  rate_limit = 700
  retry_limit = 3
}

resource "vultr_server" "ubuntu_20_04" {
    plan_id = "201"
    region_id = "4"
    os_id = "387" // TODO: put this in an array for programatic creation
    script_id = "724476" // This is where the magic happens
    ssh_key_ids = ["5ec4513d44b0f"]
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = "${vultr_server.ubuntu_20_04.main_ip}"
      private_key = "${chomp(file("/tmp/id_rsa"))}"
    }
    inlin
    source      = "slurm_20.02.1_amd64.snap"
    destination = "/tmp/slurm_20.02.1_amd64.snap"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = "${vultr_server.ubuntu_20_04.main_ip}"
      private_key = "${chomp(file("/tmp/id_rsa"))}"
    }
    inline = [
      "snap install --dangerous /tmp/slurm_20.02.1_amd64.snap",
      "snap connect slurm:network-control",
      "snap connect slurm:system-observe",
      "sudo snap connect slurm:hardware-observe",
      "snap set slurm snap.mode=all",
    ]
  }
}

output "ip_address" {
  value = vultr_server.ubuntu_20_04.main_ip
}
