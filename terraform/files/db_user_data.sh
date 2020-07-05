#!/usr/bin/env bash
playbook="/tmp/db_ansible.yml"
region="${REGION}"
amazon-linux-extras install ansible2
#aws ssm get-parameter --name "$ssm_param" --region=$region --query Parameter.Value --output text |base64 -d > $playbook
cat > $playbook << EOPB
---
- name: configure db host
  hosts: localhost
  connection: local
  gather_facts: no
  vars:
    - db_dir: "${DB_ROOT_DIR}"
    - mysql_user: "mysql"
    - mysql_group: "mysql"
    - project: "${PROJECT}"
  tasks:
    - name: create file system
      filesystem:
        dev: /dev/xvdh
        fstype: ext4
    - name: mount FS
      mount:
        src: /dev/xvdh
        path: '{{ db_dir }}'
        state: mounted
        fstype: ext4
    - name: install mariadb
      yum:
        name:
          - mariadb-server
          - python2-pip
        state: installed
    - name: chown_db_dir
      file:
        path: '{{ db_dir }}'
        owner: '{{ mysql_user }}'
        group: '{{ mysql_group }}'
        mode: '1755'
    - name: start mariadb
      service:
        name: mariadb
        state: started
        enabled: yes
    - name: install pip
      pip:
        name:
          - boto3
          - botocore
          - PyMySQL
    - name: ssm data
      set_fact:
        db_root: "{{ lookup('aws_ssm', '${DB_ROOT_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
        wp_db: "{{ lookup('aws_ssm', '${WP_DB_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
        wp_db_name: "{{ lookup('aws_ssm', '${WP_DB_NAME_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
      no_log: True
    - name: get facts
      uri:
        url: "http://169.254.169.254/latest/dynamic/instance-identity/document"
        return_content: true
        headers:
          Content-type: "application/json"
      register: result
    - name: set hostname
      hostname:
        name: "{{ result.json.instanceId }}"
    - name: change root pw
      mysql_user:
        name: "{{ db_root.user }}"
        password: "{{ db_root.password }}"
        login_user: "{{ db_root.user }}"
        check_implicit_admin: yes
        state: present
      no_log: true
    - name: create DB
      mysql_db:
        login_user: "{{ db_root.user }}"
        login_password: "{{ db_root.password }}"
        name: "{{ wp_db_name.name }}"
        state: present
    - name: create user
      mysql_user:
        login_user: "{{ db_root.user }}"
        login_password: "{{ db_root.password }}"
        name: "{{ wp_db.user }}"
        password: "{{ wp_db.password }}"
        priv: "{{ wp_db_name.name }}.*:ALL,GRANT"
        host: "{{ item }}"
        state: present
      no_log: true
      with_items:
        - "%"
        - "localhost"
EOPB
/usr/bin/ansible-playbook $playbook
rm $playbook
yum remove -y ansible