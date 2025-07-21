module "koco_vpc" {
  source              = "../../modules/vpc"

  stage               = var.stage
  servicename         = var.servicename
  tags                = var.vpc_tags

  az                  = var.az
  vpc_ip_range        = var.vpc_ip_range

  subnet_public_az1   = var.subnet_public_az1
  subnet_public_az2   = var.subnet_public_az2
  subnet_service_az1  = var.subnet_service_az1
  subnet_service_az2  = var.subnet_service_az2
  subnet_db_az1       = var.subnet_db_az1
  subnet_db_az2       = var.subnet_db_az2
}

module "koco_security_group" {
  source = "../../modules/security_group"
  stage               = var.stage
  servicename         = var.servicename

  vpc_id = module.koco_vpc.vpc_id
  vpc_cidr_block = var.vpc_ip_range
  node_group_sg_id = ""
}

module "openvpn" {
    source = "../../modules/openvpn"
    
    stage               = var.stage
    servicename         = var.servicename
    tags                = var.openvpn_tags
    
    vpc_id = module.koco_vpc.vpc_id
    subnet_id = module.koco_vpc.public_az1_id
    vpc_security_group_ids = [module.koco_security_group.sg_openvpn_id]
}

module "db" {
    source = "../../modules/db_instance"

    stage               = var.stage
    servicename         = var.servicename
    tags                = var.openvpn_tags

    subnet_private_id = module.koco_vpc.db_az1_id
    security_group_db_sg_id = module.koco_security_group.sg_db_id
    ip = var.db_ip

    depends_on = [ module.koco_vpc ]
}