########################################################
###      Manifest file by Andrii Maslovskyi v.1.0     ###
###                 GB playground                    ###
########################################################

### Describe main networx ###

data "vkcs_networking_network" "extnet" {
  name = var.ext-net
}

resource "vkcs_networking_network" "compute" {
  name = var.net
}

resource "vkcs_networking_subnet" "compute" {
  name       = "subnet_1"
  network_id = vkcs_networking_network.compute.id
  cidr       = var.cidr
}

resource "vkcs_networking_router" "compute" {
  name                = "router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "compute" {
  router_id = vkcs_networking_router.compute.id
  subnet_id = vkcs_networking_subnet.compute.id
}

resource "vkcs_networking_secgroup" "secgroup" {
  name        = "security_group"
  description = "terraform security group"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule_1" {
  direction = "ingress"
  port_range_max    = 22
  port_range_min    = 22
  protocol          = "tcp"
  remote_ip_prefix  = var.admin
  security_group_id = vkcs_networking_secgroup.secgroup.id
  description       = "sg for ssh access"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule_2" {
  direction = "ingress"
  port_range_max    = 80
  port_range_min    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  protocol          = "tcp"
  security_group_id = vkcs_networking_secgroup.secgroup.id
  description       = "sg for http access"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule_3" {
  direction = "ingress"
  port_range_max    = 443
  port_range_min    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  protocol          = "tcp"
  security_group_id = vkcs_networking_secgroup.secgroup.id
  description       = "sg for https access"
}

### Describe Compute instance ###

data "vkcs_compute_flavor" "compute" {
  name = "Basic-1-1-10"
}

resource "vkcs_compute_instance" "compute1" {
  name              = var.ci-name1
  flavor_id         = data.vkcs_compute_flavor.compute.id
  security_groups   = ["security_group"]
  key_pair          = "gb-node01-MztDPk59"
  image_id          = data.vkcs_images_image.compute.id
  availability_zone = "MS1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid        = vkcs_networking_network.compute.id
    fixed_ip_v4 = "192.168.10.13"
  }

  depends_on = [
    vkcs_networking_network.compute,
    vkcs_networking_subnet.compute
  ]
}

resource "vkcs_compute_instance" "compute2" {
  name              = var.ci-name2
  flavor_id         = data.vkcs_compute_flavor.compute.id
  security_groups   = ["security_group"]
  key_pair          = "gb-node01-MztDPk59"
  image_id          = data.vkcs_images_image.compute.id
  availability_zone = "GZ1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid        = vkcs_networking_network.compute.id
    fixed_ip_v4 = "192.168.10.14"
  }

  depends_on = [
    vkcs_networking_network.compute,
    vkcs_networking_subnet.compute
  ]
}

### added elastic ips for instances

resource "vkcs_networking_floatingip" "fip1" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_networking_floatingip" "fip2" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip1" {
  floating_ip = vkcs_networking_floatingip.fip1.address
  instance_id = vkcs_compute_instance.compute1.id
}

resource "vkcs_compute_floatingip_associate" "fip2" {
  floating_ip = vkcs_networking_floatingip.fip2.address
  instance_id = vkcs_compute_instance.compute2.id
}

### instance ami

data "vkcs_images_image" "compute" {
  name = "Ubuntu-18.04-Standard"
}

### Load balancer describe

resource "vkcs_lb_loadbalancer" "loadbalancer" {
  name          = "loadbalancer"
  vip_subnet_id = vkcs_networking_subnet.compute.id
  tags          = ["tag1"]
}

resource "vkcs_lb_listener" "listener" {
  name            = "listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = vkcs_lb_loadbalancer.loadbalancer.id
}

resource "vkcs_lb_pool" "pool" {
  name        = "pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = vkcs_lb_listener.listener.id
}

resource "vkcs_lb_member" "member_1" {
  address       = "192.168.10.13"
  protocol_port = 80
  pool_id       = vkcs_lb_pool.pool.id
  subnet_id     = vkcs_networking_subnet.compute.id
  weight        = 0
}

resource "vkcs_lb_member" "member_2" {
  address       = "192.168.10.14"
  protocol_port = 80
  pool_id       = vkcs_lb_pool.pool.id
  subnet_id     = vkcs_networking_subnet.compute.id
}
