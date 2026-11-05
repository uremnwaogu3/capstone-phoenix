output "server_public_ip" {
  value = module.compute.server_public_ip
}

output "server_private_ip" {
  value = module.compute.server_private_ip
}

output "worker_public_ips" {
  value = module.compute.worker_public_ips
}

output "worker_private_ips" {
  value = module.compute.worker_private_ips
}