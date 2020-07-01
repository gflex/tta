#!/usr/bin/env bash
amazon-linux-extras install ansible2
aws ssm get-parameter --name "/rbt/db/setup/ansible" --region=eu-central-1 --query Parameter.Value --output text |base64 -d > /tmp/db_ansible.yml
/usr/bin/ansible-playbook /tmp/db_ansible.yml