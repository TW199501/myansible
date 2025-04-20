#!/bin/bash
# 建立精簡版 Ansible 專案目錄

PROJECT_NAME="myansible"
ROLE_NAME="nginx"

echo "建立專案目錄：$PROJECT_NAME"

mkdir -p "$PROJECT_NAME"/{inventories/{production,staging},roles/$ROLE_NAME/{tasks,handlers,templates,vars},playbooks,tools}

# 建立 ansible.cfg
cat > "$PROJECT_NAME/ansible.cfg" <<EOF
[defaults]
inventory = inventories/production/hosts
roles_path = ./roles
host_key_checking = False
EOF

# 建立 hosts 檔
echo "[web]" > "$PROJECT_NAME/inventories/production/hosts"
echo "[web]" > "$PROJECT_NAME/inventories/staging/hosts"

# 建立 nginx role 的基本檔案
touch "$PROJECT_NAME/roles/$ROLE_NAME/tasks/main.yml"
touch "$PROJECT_NAME/roles/$ROLE_NAME/handlers/main.yml"
touch "$PROJECT_NAME/roles/$ROLE_NAME/templates/nginx.conf.j2"
touch "$PROJECT_NAME/roles/$ROLE_NAME/vars/main.yml"

# 建立 playbook
cat > "$PROJECT_NAME/playbooks/nginx_setup.yml" <<EOF
---
- name: Setup nginx on web servers
  hosts: web
  become: true
  roles:
    - nginx
EOF

# 建立 README.md
cat > "$PROJECT_NAME/README.md" <<EOF
# $PROJECT_NAME

簡化版的 Ansible 專案架構，包含 nginx role。
EOF

echo "專案初始化完成：$PROJECT_NAME"

# 建立 SSH 金鑰並推送到所有主機以啟用免密登入
ls ~/.ssh/id_rsa ~/.ssh/id_rsa.pub 2>/dev/null || {
    echo "SSH 金鑰不存在，請先建立 SSH 金鑰"
    exit 1
}
# 建立金鑰
ssh-keygen -t rsa -b 4096

# 安裝必要元件
sudo apt update && sudo apt install -y \
    ansible \
    python3 python3-pip \
    openssh-client \
    make
    tree












