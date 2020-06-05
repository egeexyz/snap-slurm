variable "api_key" {
  type = string
}

locals {
  plan_id = "400"
  region_id = "1"
  ssh_key_ids = ["5ec4513d44b0f"]
  priv_key_path = "/home/egee/.ssh/id_rsa"#"/tmp/id_rsa"
  filename = "slurm_20.02.1_amd64.snap"
  ubuntu = ["270", "387"]
  ubuntu_2004 = "387"
  ubuntu_1804 = "270"
  centos8 = "362"
}


provider "vultr" {
  api_key = var.api_key
  rate_limit = 700
  retry_limit = 3
}

resource "vultr_server" "ubuntu" {
  count = length(local.ubuntu)
  plan_id = local.plan_id
  region_id = local.region_id
  os_id = element(local.ubuntu, count.index)
  ssh_key_ids = local.ssh_key_ids
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = self.main_ip
      private_key = file(local.priv_key_path)
    }
    source      = local.filename
    destination = "/tmp/${local.filename}"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = self.main_ip
      private_key = file(local.priv_key_path)
    }
    script = "scripts/slurm-test.sh"
  }
}

# resource "vultr_server" "ubuntu_18_04" {
#     plan_id = local.plan_id
#     region_id = local.region_id
#     os_id = local.ubuntu_1804
#     ssh_key_ids = local.ssh_key_ids
#   provisioner "file" {
#     connection {
#       type     = "ssh"
#       user     = "root"
#       host     = self.ubuntu_18_04.main_ip
#       private_key = file(local.priv_key_path)
#     }
#     source      = local.filename
#     destination = "/tmp/${local.filename}"
#   }
#   provisioner "remote-exec" {
#     connection {
#       type     = "ssh"
#       user     = "root"
#       host     = self.ubuntu_18_04.main_ip
#       private_key = file(local.priv_key_path)
#     }
#     inline = local.ubuntu_cmds
#   }
# }

# resource "vultr_server" "centos8" {
#     plan_id = local.plan_id
#     region_id = local.region_id
#     os_id = local.centos8
#     ssh_key_ids = local.ssh_key_ids
#   provisioner "file" {
#     connection {
#       type     = "ssh"
#       user     = "root"
#       host     = self.centos8.main_ip
#       private_key = file(local.priv_key_path)
#     }
#     source      = local.filename
#     destination = "/tmp/${local.filename}"
#   }
#   provisioner "remote-exec" {
#     connection {
#       type     = "ssh"
#       user     = "root"
#       host     = self.centos8.main_ip
#       private_key = file(local.priv_key_path)
#     }
#     inline = local.centos8_cmds
#   }
# }
