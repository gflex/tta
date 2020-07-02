resource "aws_ssm_activation" "ssm_service" {
  //  iam_role = aws_iam_role.ec2_common_role.name
  iam_role           = aws_iam_role.ec2_common_role.name
  description        = "SSM Session manager activation"
  name               = "${var.project}_ssm_activation"
  registration_limit = 5
  tags               = local.common_tags
}

//resource "aws_key_pair" "deployer" {
//  key_name   = "deployer-ssh-keys"
//  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDItsgj5JBqzKQR/DndjkJ2bKfNnYEf8cV3udQuR98w5d92r5aXkcUjt5Lk3ZI2JYAIU2DpfLTWpYeVWfKXdvI6gaeSx6n6+KdQvFLGSojgZ11U1f5KdyM6x1krE6fwKIQy5kEsjtLXQJQPhA2d3PU96c8LMlMu2bUZ62ocsQ0LHirErLE5PSYFw4HTx6wr7dHV5p3DKQt37aaEzCQZKdFEi1R2HbgEjZWVF8XVwB+GVeigmPUNjUoQzeDCsN74BJFbHqOzDJ19S5C2tGySPdxw+DYmeQLz31Xs7TiKUsLfr4PExVn62HOev1aoastz5Ukkn75H6Xn4+eS9U+EoKyH4wtCvKo/3OvIHmavEOs67Y5uJkvbOgE4c6UX4oohHEkosH//pbohKBAsGyx16rxP+paLZ1bb7lcR8b1pKhBieL4EDdEflse6SGh12cZBHUFq4yMNTwhipZqJdBqvd3kXH1yVlSxEy0a9w70L5Ga2To1kkrxWPMkKekaWksBQto7Etu9M0vXGF0DCUGKKfy4utT+Uk/c1M0gh+dzHgQ5VdgLl9QrFTNuXOoZbLqkktBljLFqK9I9yZnA4JDFjPW3wUb2jAfPBIFURQyoTiqnj468jR0gfdF/O/BoqXrBxw6VHl47Q8fMtZHkpz2Nk9q8NeKMDUiJf2P9YOrMhD4hkqtw== georgi.ivanov@helecloud.com"
//}
