#Both public and private IPs of the workers and servers to be passed out of the module
output "server_public_ip" {
  value = aws_eip.server.public_ip
}

output "server_private_ip" {
  value = aws_instance.server.private_ip
}

output "worker_public_ips" {
  value = aws_eip.worker[*].public_ip
}

output "worker_private_ips" {
  value = aws_instance.worker[*].private_ip
}