variable "api_key" {
  type = string
}

module "test_data" {
  source = "../../tests"
}

provider "vultr" {
  api_key = var.api_key
  rate_limit = 700
  retry_limit = 3
}

resource "vultr_server" "ubuntu1804" {
  plan_id = module.test_data.plan_id
  region_id = module.test_data.region_id
  os_id = module.test_data.ubuntu_1804
  ssh_key_ids = module.test_data.ssh_key_ids
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = self.main_ip
      private_key = file(module.test_data.priv_key_path)
    }
    source      = module.test_data.filename
    destination = "/tmp/${module.test_data.filename}"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      host     = self.main_ip
      private_key = file(module.test_data.priv_key_path)
    }
    script = "../slurm-test.sh"
  }
}