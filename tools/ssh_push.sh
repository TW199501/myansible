#!/bin/bash
# myansible/tools/ssh_push.sh
# 用途：將 SSH 金鑰推送到所有主機以啟用免密登入

    set -euo pipefail

    ANSIBLE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    HOSTS_FILE="$ANSIBLE_DIR/inventories/production/hosts"
    SSH_USER="${1:-root}"

# 檢查 hosts 檔案是否存在
    if [ ! -f "$HOSTS_FILE" ]; then
        echo " 找不到 hosts 檔案：$HOSTS_FILE"
        exit 1
    fi

# 產生 SSH 金鑰（如果尚未存在）
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo " 尚未產生 SSH 金鑰，正在建立中..."
        ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
    fi

# 擷取所有主機 IP（忽略註解、群組名、空行）
    HOSTS=$(grep -vE '^\[|^#|^$' "$HOSTS_FILE")

# 發送金鑰
    for HOST in $HOSTS; do
        echo "傳送 SSH 金鑰到 $SSH_USER@$HOST ..."
        ssh-copy-id "$SSH_USER@$HOST"
    done

echo "所有主機免密登入設定完成"

