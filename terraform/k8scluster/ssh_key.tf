
# the way to get the private key is to run following commands
# cat terraform.tfstate | jq -r '.resources[] | select (.module == "module.networking" and .type == "tls_private_key" and .name == "ssh") | .instances[0].attributes.private_key_openssh' > ~/.ssh/k8s.key
# chmod 400 ~/.ssh/k8s.key
# ssh -i ~/.ssh/k8s.key ubuntu@<public_ip>
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}