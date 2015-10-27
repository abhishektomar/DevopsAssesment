module "aws-vpc" {
    source = "../../infra/aws-vpc"
    my_ip = "${var.my_ip}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    key_name   = "${var.key_name}"
    project_name = "${var.project_name}"
    vpc_cidr = "${var.vpc_cidr_us}"
    vpc_cidr_us = "${var.vpc_cidr_us}"
    public_subnet_cidr_a = "${var.public_subnet_cidr_a_us}"
    public_subnet_cidr_b = "${var.public_subnet_cidr_b_us}"
    private_subnet_cidr_a = "${var.private_subnet_cidr_a_us}"
    private_subnet_cidr_b = "${var.private_subnet_cidr_b_us}"
    az_a = "${var.az_a}"
    az_b = "${var.az_b}"
    nat_userdata = "${var.nat_userdata_us}"
    region = "${var.region}"
    ami = "${var.ami-us-east-1}"
    instance_type = "${var.nat_instance_type}"
}

module "iam_role_ec2fullaccess" {
    source = "../../infra/aws-iam"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    role_name = "${var.role_name}"
}
    
module "sg_puppet" {
    source = "../../infra/aws-sg/puppet-sg"
    access_key = "${var.access_key}"
    my_ip = "${var.my_ip}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    security_group_name = "${var.sg_name}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    source_cidr_block = "${var.source_cidr_block}"
}

module "puppet" {
    source = "../../infra/aws-instance"
    subnet_id = "${module.aws-vpc.subnet_id_public_a}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    key_name = "${var.key_name}"
    instance_iam_role = "${var.instance_role}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    ami = "${var.ami-us-east-1}"
    region = "${var.region}"
    userdata = "${var.puppet_userdata_us}"
    instance_tag = "${var.instance_tag}"
    instance_type = "${var.puppet_instance_type}"
    security_group = "${module.sg_puppet.security_group_id}"
}

module "puppet_eip" {
    source = "../../infra/aws-eip"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    instance_id = "${module.puppet.instance_id}"
}

module "web_elb" {
    source = "../../infra/aws-elb"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    elb_name = "${var.elb_name}"
    subnet_id1 = "${module.aws-vpc.subnet_id_public_a}" 
    subnet_id2 = "${module.aws-vpc.subnet_id_public_b}"
    vpc_cidr = "${var.vpc_cidr_us}"
    vpc_id = "${module.aws-vpc.vpc_id}"
}

module "sg_web" {
    source = "../../infra/aws-sg/web-sg"
    access_key = "${var.access_key}"
    my_ip = "${var.my_ip}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    security_group_name = "${var.web_sg_name}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    source_cidr_block = "${var.source_cidr_block}"
}

module "web" {
    source = "../../infra/aws-instance"
    subnet_id = "${module.aws-vpc.subnet_id_public_a}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    key_name = "${var.key_name}"
    instance_iam_role = "${var.instance_role}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    ami = "${var.ami-us-east-1}"
    region = "${var.region}"
    userdata = "${var.web_userdata_us}"
    instance_tag = "${var.web_instance_tag}"
    instance_type = "${var.web_instance_type}"
    security_group = "${module.sg_web.security_group_id}"
}

#module "web_eip" {
#    source = "../../infra/aws-eip"
#    access_key = "${var.access_key}"
#    secret_key = "${var.secret_key}"
#    region = "${var.region}"
#    instance_id = "${module.web.instance_id}"
#}

module "sg_postgresql" {
    source = "../../infra/aws-sg/postgresql-sg"
    access_key = "${var.access_key}"
    my_ip = "${var.my_ip}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    security_group_name = "${var.sg_name}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    source_cidr_block = "${var.source_cidr_block}"
}

module "postgresql" {
    source = "../../infra/aws-instance"
    subnet_id = "${module.aws-vpc.subnet_id_private_a}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    key_name = "${var.key_name}"
    instance_iam_role = "${var.instance_role}"
    instance_count = "${var.pg_instance_count}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    ami = "${var.ami-us-east-1}"
    region = "${var.region}"
    userdata = "${var.pg_userdata_us}"
    instance_tag = "${var.pg_instance_tag}"
    instance_type = "${var.pg_instance_type}"
    security_group = "${module.sg_postgresql.security_group_id}"
}

module "pgpool" {
    source = "../../infra/aws-instance"
    subnet_id = "${module.aws-vpc.subnet_id_private_a}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    key_name = "${var.key_name}"
    instance_count = "${var.pgpool_instance_count}"
    instance_iam_role = "${var.instance_role}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    ami = "${var.ami-us-east-1}"
    region = "${var.region}"
    userdata = "${var.pgpool_userdata_us}"
    instance_tag = "${var.pgpool_instance_tag}"
    instance_type = "${var.pg_instance_type}"
    security_group = "${module.sg_postgresql.security_group_id}"
}

module "sg_mongo" {
    source = "../../infra/aws-sg/mongo-sg"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    region = "${var.region}"
    security_group_name = "${var.sg_name}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    source_cidr_block = "${var.source_cidr_block}"
}

module "mongo" {
    source = "../../infra/aws-instance"
    subnet_id = "${module.aws-vpc.subnet_id_private_b}"
    vpc_id = "${module.aws-vpc.vpc_id}"
    key_name = "${var.key_name}"
    instance_count = "${var.mongo_instance_count}"
    instance_iam_role = "${var.instance_role}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    my_ip = "${var.my_ip}"
    ami = "${var.ami-us-east-1}"
    region = "${var.region}"
    userdata = "${var.mongo_userdata_us}"
    instance_tag = "${var.mongo_instance_tag}"
    instance_type = "${var.mongo_instance_type}"
    security_group = "${module.sg_mongo.security_group_id}"
}

module "sg_as" {
    source = "../../infra/aws-sg/web-sg"
    access_key = "${var.access_key}"
    my_ip = "${var.my_ip}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    security_group_name = "as"
    vpc_id = "${module.aws-vpc.vpc_id}"
    source_cidr_block = "${var.source_cidr_block}"
}

module "web_as" {
    source = "../../infra/aws-as"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    as_name = "${var.project_name}"
    as_ami = "${var.web_ami}"
    as_instance_type = "${var.web_instance_type}"
    as_sg = "${module.sg_as.security_group_id}"
    as_user_data = "${var.as_user_data}"
    key_name   = "${var.key_name}"
    availability_zones = "${var.as_zones}"
    asg_max = "${var.asg_max}"
    asg_min = "${var.asg_min}"
    asg_desired = "${var.asg_desired}"
    as_elb_name = "${module.web_elb.elb_name}"
    instance_role = "${var.instance_role}"
    subnet_ids = "${module.aws-vpc.subnet_id_public_b},${module.aws-vpc.subnet_id_public_a}"    
}
