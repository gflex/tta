#!/usr/bin/env bash
playbook="/tmp/db_ansible.yml"
region="${REGION}"
ssm_param="${ANS_APP_SSM}"
amazon-linux-extras install ansible2
aws ssm get-parameter --name "$ssm_param" --region=$region --query Parameter.Value --output text |base64 -d > $playbook
/usr/bin/ansible-playbook $playbook
rm $playbook
yum remove -y ansible