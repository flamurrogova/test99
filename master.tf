
resource "libvirt_volume" "cloud_image" {
  count = var.instance_count
  name  = "${var.hostname}-${count.index}.${var.domain}"
  size  = var.root_disk_bytes

  base_volume_pool = "default"
  base_volume_name = var.cloud_image
}

data "template_file" "user_data" {
  count    = var.instance_count
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = "${var.hostname}-${count.index}"
    fqdn     = "${var.hostname}-${count.index}.${var.domain}"
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count     = var.instance_count
  name      = "${var.hostname}-${count.index}.${var.domain}.commoninit.iso"
  user_data = data.template_file.user_data[count.index].rendered
}


# Define KVM domain to create
resource "libvirt_domain" "my_domain_masters" {
  name   = "${var.hostname}-${count.index}.${var.domain}"
  memory = var.memory
  vcpu   = var.cpu
  count  = var.instance_count

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.cloud_image[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

