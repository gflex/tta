## Description
tta project for Georgi Ivanov

### Task

Create semi-distributed Wordpress installation on two instances in AWS and using DB from 3rd host.

### Solution
Solution is based on Terraform and Ansible, used for building AWS infrastructue and setting up DB host and Web servers respectively.

With terraform we:
1. Create a new VPC
1. Create 2 from each public (public access), application and DB subnets (private) in two availability zones.
1. Create  Internet gateway
1. Create NAT gateway in each public net (respectively in each availability zone)
1. Fix routing. Each subnet goes Internet via its availability zone's NAT Gateway
1. Create security groups allowing only the minimal traffic between respective networks part of the security groups
1. Create IAM roles, profiles and attach respective policies.
1. Configure System Manager's Session manager in order to reach instances over SSM and not opening SSH public access to the instances.
1. Bring up ec2 instance for DB host based on latest Amazon Linux AMI (dynamically queried for) and attach EBS volume for storing DB data.
1. Create Launch template for automatically spinning new instances for Web servers.
1. Create Load balancer target group, listener and load balancer in the public net distributing the load between available Web servers.
1. Create autoscaling group to monitor after web servers availability and spin up new instances should any is unavailable/down


Ansible is used in both DB host and Launch template configuration user data to actually install and configure respective software.
Thanks to Stateful nature of terraform and declarativeness of Ansible, we achieve idempotency in actions.

There are no passwords stored in the repo. Whenever password is needed, it's automatically generated by Terraform on the fly and stored as SecureString in SSM Parameter store.  
Then during Ansible playbook execution, parameters are automatically obtained and applied. Sensitive data is obfuscated from Ansible logs.

For the sake of simplicity installation is only reachable via **http** and not *https*

Steps:
##### Remote terraform.state file
1. Make sure you have valid credentials for your AWS account in $HOME/.aws directory and/our your correct credentials are loaded (for example with tools like `awsume`)
1. Clone current repo
1. cd to the `state` directory
1. Frist step is to craete the S3 bucket that will be holding the remote state. Open `terraform.tfvars` and edit respective parameters. Make sure to use only URL friendly symbols.
1. Run `terraform init` to initialize
1. Run `terraform plan` to check correct configuratin.
1. Now apply the configuratin with `terraform apply` and type in `yes` when prompted
1. Upon successfull completion you'll see the just created S3 bucket ID:
   ```
   aws_s3_bucket.terraform_state: Creating...  
   aws_s3_bucket.terraform_state: Creation complete after 6s [id=XXXXXXXXX]
   ``` 
   Copy the id 
1. cd to `terraform` dir and paste the id into `terraform/state.tf` as `bucket` parameter value
1. open `terraform.tfvars` file to edit configuration variables:
     * `aws_region`
     * `vpc_subnet`
     * `user` - used for tagging
     * `project` - used for tagging
     * `public_nets`
     * `private_nets`
1. run `terraform init`
2. run `terraform plan`. Validate the plan
2. run `terraform apply` and one prompted for confirmation type in `yes`
3. After successful completion, URL for accessing your Wordpress installation will be printed. By default, password is hidden as sensitive data. Hence, to reveal it run `terraform output wp_admin_password`


Due to the needed time for actual bootstrap process, service might need some time to start. During that time you may see `502 Bad Gateway` error. Try refreshing in couple of minutes.

Destroying everything including the built infra is as easy as:
`terraform destroy`
Thanks to the share remote state file, various team members are able to work on the project semi-simultaneously without messing up with the already built infra.

