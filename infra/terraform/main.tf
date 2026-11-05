#Calling the module from the root
module "network" {
  source = "./modules/network"
  name   = var.project_name

}
#calling the module from the root
module "security" {
  source     = "./modules/security"
  name       = var.project_name
  vpc_id     = module.network.vpc_id
  admin_cidr = var.admin_cidr
}

#calling the compute module from the root
module "compute" {
  source               = "./modules/compute"
  name                 = var.project_name
  subnet_id            = module.network.public_subnet_id
  security_group_id    = module.security.security_group_id
  public_key           = file(pathexpand(var.public_key_path))
  worker_count         = var.worker_count
  server_instance_type = var.server_instance_type
  worker_instance_type = var.worker_instance_type

  depends_on = [module.network]

}