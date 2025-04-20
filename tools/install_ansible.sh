#!/bin/bash
# 安裝 Ansible 主控端執行環境 + 開發輔助工具（Ubuntu / Debian）

set -euo pipefail

echo "🟢 更新套件庫..."
sudo apt update

echo "🟢 安裝必要工具：Ansible, Python3, SSH, Git, Make, jq, tree..."
sudo apt install -y \
    ansible \
    python3 python3-pip \
    openssh-client \
    git \
    make \
    tree \
    jq \
    sshpass \
    ansible-lint \
    curl

echo "🟢 安裝 Python 工具：ansible-lint, yamllint, pre-commit, ansible-navigator..."
pip install --upgrade pip
pip install \
    ansible-lint \
    yamllint \
    pre-commit \
    ansible-navigator

echo "✅ 所有工具安裝完成！"

echo ""
echo "📦 建議驗證指令："
echo "  ansible --version"
echo "  ansible-lint --version"
echo "  yamllint --version"
echo "  pre-commit --version"
echo "  ansible-navigator --version"
echo ""
echo "📘 補充說明："
echo "  - ansible-lint    ：檢查 Ansible Playbook 結構與寫法"
echo "  - yamllint        ：通用 YAML 語法檢查"
echo "  - pre-commit      ：開發前自動檢查流程（可加到 git hook）"
echo "  - ansible-navigator：互動式 CLI 工具，整合 lint、playbook 執行"