#!/usr/bin/env bash
set -e
playbook="/tmp/wp_ansible.yml"
amazon-linux-extras install -y ansible2
cat > $playbook << EOPB
---
- name: configure web server
  hosts: localhost
  connection: local
  gather_facts: no
  vars:
    wp_dir: "${WPDIR}"
    admin_mail: "${ADMIN_MAIL}"
    project: "${PROJECT}"

  tasks:
    - name: install needed software
      yum:
        name:
          - httpd
          - python2-pip
          - mysql
        state: installed

    - name: install pip
      pip:
        name:
          - boto3
          - botocore
          - PyMySQL

    - name: get ssm data
      set_fact:
        wp_db: "{{ lookup('aws_ssm', '${WP_DB_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
        wp_db_name: "{{ lookup('aws_ssm', '${WP_DB_NAME_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
        wp_admin: "{{ lookup('aws_ssm', '${WP_ADMIN_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
        wp_blog: "{{ lookup('aws_ssm', '${WP_BLOG_SSM}', region='${REGION}', shortnames=true, bypath=true, recursive=true) }}"
      no_log: True

    - name: retry connecting to db host for 4 mins
      mysql_db:
        login_host: "{{ wp_db_name.host }}"
        login_user: "{{ wp_db.user }}"
        login_password: "{{ wp_db.password }}"
        name: "{{ wp_db_name.name }}"
        state: present
      register: result
      retries: 12
      delay: 20
      until: result is not failed

    - name: install wordpress
      shell: "{{ item }}"
      with_items:
        - "amazon-linux-extras install -y epel php7.3"
        - "yum install -y wp-cli"
        - "/usr/bin/wp --path={{ wp_dir }} core download"
        - "/usr/bin/wp --path={{ wp_dir }} core config --dbname={{ wp_db_name.name }} --dbuser={{ wp_db.user }} --dbpass=\'{{ wp_db.password }}\' --dbhost={{ wp_db_name.host }} --dbprefix=wp_"
        - "/usr/bin/wp --path={{ wp_dir }} core install --url={{ wp_db.url }} --title=wordpress --admin_user={{ wp_admin.user }} --admin_password=\'{{ wp_admin.password }}\' --admin_email={{ admin_mail }}"
      no_log: True

    - name: fix dir permissions
      file:
        path: "{{ wp_dir }}"
        recurse: yes
        owner: ec2-user
        group: apache
        mode: u=rwX,g=rwX,o=rX

    - name: start httpd
      service:
        name: httpd
        state: restarted
        enabled: yes

    - name: get instance facts
      uri:
        url: "http://169.254.169.254/latest/dynamic/instance-identity/document"
        return_content: true
        headers:
          Content-type: "application/json"
      register: result

    - name: set hostname
      hostname:
        name: "{{ result.json.instanceId }}"

    - name: set tag and update post
      shell: |
        aws ec2 create-tags --region "{{ result.json.region }}" --resources "{{ result.json.instanceId }}" --tags Key=Name,Value="{{ project }}-wp-{{ result.json.pendingTime }}"
        wp post update 1 --path="{{ wp_dir }}" --post_content="{{ wp_blog.post1 }}" --post_title="Linux namespaces" --post_name="Linux namespaces" --post_status=publish --post_author="{{ wp_admin.user }}"
        wp comment delete 1 --path="{{ wp_dir }}" || true

EOPB
/usr/bin/ansible-playbook $playbook
rm $playbook
yum remove -y ansible