vpc_subnet = "10.13.0.0/16"
aws_region = "eu-central-1" # Frankfurt due to "DenyRegionsOutsideEU" policy
applicant  = "georgi.ivanov"
project    = "rbt"
public_nets = {
  public_net_1 : {
    cidr = "10.13.1.0/24"
    avz  = "avz1"
  },
  public_net_2 : {
    cidr = "10.13.2.0/24"
    avz  = "avz2"
  }
}

private_nets = {
  app : {
    app_net_1: {
      cidr = "10.13.3.0/24"
      avz  = "avz1"
    },
    app_net_2 : {
      cidr = "10.13.4.0/24"
      avz  = "avz2"
    }
  },
  rds : {
    rds_net_1 : {
      cidr = "10.13.5.0/24"
      avz  = "avz1"
    },
    rds_net_2 : {
      cidr = "10.13.6.0/24"
      avz  = "avz2"
    }
  }
}