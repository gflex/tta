resource "aws_ssm_activation" "ssm_service" {
  //  iam_role = aws_iam_role.ec2_common_role.name
  iam_role           = aws_iam_role.ec2_common_role.name
  description        = "SSM Session manager activation"
  name               = "${var.project}_ssm_activation"
  registration_limit = 5
  tags               = local.common_tags
}
