vpc_subnet = "10.13.0.0/16"
aws_region = "eu-central-1" # Frankfurt due to "DenyRegionsOutsideEU" policy
applicant  = "georgi.ivanov"
project    = "rbt"
pub_nets = [ "10.13.1.0/24", "10.13.2.0/24"]
app_nets = ["10.13.3.0/24","10.13.4.0/24"]
rds_nets = ["10.13.5.0/24","10.13.6.0/24"]