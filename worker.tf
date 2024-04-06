
resource "libvirt_volume" "cloud_image_worker" {
  count = var.instance_count_worker
  name  = "${var.hostname_worker}-${count.index}.${var.domain}"
  size  = var.root_disk_bytes

  base_volume_pool = "default"
  base_volume_name = var.cloud_image
}

data "template_file" "user_data_worker" {
  count    = var.instance_count_worker
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = "${var.hostname_worker}-${count.index}"
    fqdn     = "${var.hostname_worker}-${count.index}.${var.domain}"
  }
}

resource "libvirt_cloudinit_disk" "commoninit_worker" {
  count     = var.instance_count_worker
  name      = "${var.hostname_worker}-${count.index}.${var.domain}.commoninit.iso"
  user_data = data.template_file.user_data_worker[count.index].rendered
}


# Define KVM domain to create
resource "libvirt_domain" "my_domain_workers" {
  name   = "${var.hostname_worker}-${count.index}.${var.domain}"
  memory = var.memory_worker
  vcpu   = var.cpu_worker
  count  = var.instance_count_worker

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.cloud_image_worker[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit_worker[count.index].id

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

