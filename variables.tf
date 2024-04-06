# masters
variable "hostname" { default = "k8s-master" }
variable "domain" { default = "example.com" }
variable "memory" { default = 1024 * 4 }
variable "cpu" { default = 4 }
variable "root_disk_bytes" { default = 1024 * 1024 * 1024 * 20 }
variable "instance_count" { default = "0" }
variable "cloud_image" { default = "focal-server-cloudimg-amd64.img" }
#variable "cloud_image" { default="debian-10-genericcloud-amd64-20201214-484.qcow2" }

# workers
variable "hostname_worker" { default = "k8s-worker" }
variable "memory_worker" { default = 1024 * 4 }
variable "cpu_worker" { default = 4 }
variable "root_disk_bytes_worker" { default = 1024 * 1024 * 1024 * 20 }
variable "instance_count_worker" { default = "2" }

