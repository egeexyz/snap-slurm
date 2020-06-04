variable "api_key" {
  type = string
}

locals {
  plan_id = "400"
  region_id = "1"
  ssh_key_ids = ["5ec4513d44b0f"]
  priv_key_path = "/tmp/id_rsa"
  filename = "slurm_20.02.1_amd64.snap"
  ubuntu_2004 = "387"
  ubuntu_1804 = "270"
  centos8 = "362"
  ubuntu_cmds = [
      "snap install --dangerous /tmp/slurm_20.02.1_amd64.snap",
      "snap connect slurm:network-control",
      "snap connect slurm:system-observe",
      "sudo snap connect slurm:hardware-observe",
      "snap set slurm snap.mode=all",
    ]
  centos8_cmds = [
      "dnf install -y epel-release",
      "dnf upgrade -y",
      "dnf install -y snapd",
      "systemctl enable --now snapd.socket",
      "ln -s /var/lib/snapd/snap /snap",
      "snap install --dangerous /tmp/slurm_20.02.1_amd64.snap",
      "snap connect slurm:network-control",
      "snap connect slurm:system-observe",
      "sudo snap connect slurm:hardware-observe",
      "snap set slurm snap.mode=all",
    ]
}


provider "vultr" {
  api_key = var.api_key
  rate_limit = 700
  retry_limit = 3
}

resource "vultr_server" "ubuntu_20_04" {
    plan_id = local.plan_id
    region_id = local.region_id
    os_id = local.ubuntu_2004
    ssh_key_ids = local.ssh_key_ids
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.ubuntu_20_04.main_ip
      private_key = file(local.priv_key_path)
    }
    source      = local.filename
    destination = "/tmp/${local.filename}"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.ubuntu_20_04.main_ip
      private_key = file(local.priv_key_path)
    }
    inline = local.ubuntu_cmds
  }
}

resource "vultr_server" "ubuntu_18_04" {
    plan_id = local.plan_id
    region_id = local.region_id
    os_id = local.ubuntu_1804
    ssh_key_ids = local.ssh_key_ids
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.ubuntu_18_04.main_ip
      private_key = file(local.priv_key_path)
    }
    source      = local.filename
    destination = "/tmp/${local.filename}"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.ubuntu_18_04.main_ip
      private_key = file(local.priv_key_path)
    }
    inline = local.ubuntu_cmds
  }
}

resource "vultr_server" "centos8" {
    plan_id = local.plan_id
    region_id = local.region_id
    os_id = local.centos8
    ssh_key_ids = local.ssh_key_ids
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.centos8.main_ip
      private_key = file(local.priv_key_path)
    }
    source      = local.filename
    destination = "/tmp/${local.filename}"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = vultr_server.centos8.main_ip
      private_key = file(local.priv_key_path)
    }
    inline = local.centos8_cmds
  }
}
