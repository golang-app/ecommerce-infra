resource "oci_load_balancer_load_balancer" "load_balancer" {
    compartment_id = var.compartment_id
    display_name = "kubernetes-the-hard-way"
    shape = "100Mbps"
    subnet_ids = [oci_core_subnet.subnet.id]
}

resource "oci_load_balancer_backend_set" "backend_set" {
    health_checker {
        protocol = "HTTP"
        interval_ms = 10000
        port = 8888
        retries = 3
        return_code = 200
        timeout_in_millis = 3000
        url_path = "/healthz"
    }

    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    name = "controller-backend-set"
    policy = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "test_backend" {
    count = var.no_control_planes
    backendset_name = oci_load_balancer_backend_set.backend_set.name
    ip_address = "10.240.0.1${count.index}"
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    port = 6443
    weight = 1
}

resource "oci_load_balancer_listener" "listener" {
    default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    name = "controller-listener"
    port = 6443
    protocol = "TCP"
}