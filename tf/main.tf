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
  provisioner "remote-exec" {
    inline = [
      "cat /tmp/firstboot.log"
    ]
  }
}

output "ip_address" {
  value = vultr_server.ubuntu_20_04.main_ip
}
