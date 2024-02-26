provider "aws" {
  region = "${var.region}"
}

module "vpc_module" {
  source = "./modules/vpc-tf"  // path of module tf script

}

module "alb_module" {
  source = "./modules/alb-tf"  // path of module tf script
  myvpc_id = module.vpc_module.my_vpc_id  //pass variable value to module
  private_subnet_1_id = module.vpc_module.my_Pri_Subnet_1_id
  private_subnet_2_id = module.vpc_module.my_Pri_Subnet_2_id
  public_subnet_1_id = module.vpc_module.my_Pub_Subnet_1_id
  public_subnet_2_id = module.vpc_module.my_Pub_Subnet_2_id
}


//print out of module 
output "my_vpc_id" {
  value = module.vpc_module.my_vpc_id
}

output "Pub_Subnet_1_id" {
  value = module.vpc_module.my_Pub_Subnet_1_id
}
output "Pub_Subnet_2_id" {
  value = module.vpc_module.my_Pub_Subnet_2_id
}
output "Pri_Subnet_1_id" {
  value = module.vpc_module.my_Pri_Subnet_1_id
}
output "Pri_Subnet_2_id" {
  value = module.vpc_module.my_Pri_Subnet_2_id
}