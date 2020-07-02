## Create SSM Connection manager role
resource "aws_iam_role" "ec2_common_role" {
  assume_role_policy = data.template_file.tmpl_role_ec2_ssm.rendered
  name               = "${var.project}_ec2_common_role"
  tags               = merge({ "Name" : "${var.project}_ec2_common_role" }, local.common_tags)
}

## attach default SSM connection manager policy to role
resource "aws_iam_role_policy_attachment" "ssm_session" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_common_role.name
}

## attach policy to allow ec2 instances read SSM parameters store
resource "aws_iam_role_policy_attachment" "ec2_common_ssm_ro" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role = aws_iam_role.ec2_common_role.name
}

## Create and attach ec2 tagging policy
resource "aws_iam_policy" "ec2_tagging" {
  policy = data.template_file.iam_policy_ec2_tag.rendered
}

resource "aws_iam_role_policy_attachment" "attach_ec2_tagging" {
  policy_arn = aws_iam_policy.ec2_tagging.arn
  role = aws_iam_role.ec2_common_role.id
}

## Create ec2 instance role based on the ec2_common_role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.ec2_common_role.name
  name = "${var.project}_ec2_instance_profile"
}
