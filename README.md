
# myansible

Ansible 自動化專案，使用最佳實務架構，支援多環境（production / staging）、模組化角色與免密 SSH 快速佈署。

## 專案結構簡介
```bash
myansible/
├── ansible.cfg                     # Ansible 設定檔
├── inventories/                   # 主機清單（多環境）
│   ├── production/
│   │   └── hosts                  # 正式環境主機清單
│   └── staging/
│       └── hosts                  # 測試環境主機清單
├── playbooks/                     # 任務流程 YAML
│   └── ping_all.yml               # 測試所有主機連通狀態
├── roles/                         # 角色模組（模組化功能單位）
│   └── nginx/                     # 範例角色 nginx
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── templates/
│       │   └── nginx.conf.j2
│       └── vars/
│           └── main.yml
├── tools/                         # 實用工具腳本
│   └── ssh_push.sh                # SSH 免密快速部署工具
├── logs/                          # Ansible log 檔儲存位置
├── .gitignore                     # 忽略檔案設定
└── README.md                      # 專案說明文件
```


## 快速開始

1. 安裝 Ansible（建議在 WSL 或 Linux）
2. 建立免密 SSH：`./tools/ssh_push.sh root`
3. 測試所有主機連線：`ansible-playbook playbooks/ping_all.yml`

## 📦 支援功能
- 多環境切換（production / staging）
- 多角色模組（roles/）
- 免密 SSH 自動推送（tools/ssh_push.sh）
- 清晰分離變數與主機清單
EOF

第一次執行推送金鑰
ssh-copy-id root@192.168.X.X
驗證金鑰是否成功推送
ssh root@192.168.X.X

目前這樣仍然 **不對** ❌，因為：

> Ansible **仍然沒有載入你的 `/home/elf/myansible/ansible.cfg`**，而是顯示：
>
> ```
> config file = None
> ```

而且還出現這個警告：

```
[WARNING]: Ansible is being run in a world writable directory (/home/elf/myansible), ignoring it as an ansible.cfg source.
```

---

## 🧯 問題關鍵是：

> `/home/elf/myansible` 是 **world-writable**（即：任何使用者都可以寫入）

Ansible 出於安全性考量，會完全**忽略任何 world-writable 資料夾中的設定檔**（包含 `ansible.cfg`）

---

## ✅ 解法：修正專案資料夾權限

請馬上執行以下指令：

```bash
chmod o-w /home/elf/myansible
chmod g-w /home/elf/myansible
```

說明：
- `o-w` 表示移除「others（其他用戶）」對該資料夾的寫入權限
- 不會影響你自己（elf）對該目錄的存取

---

### 🔍 然後確認權限已修復：

```bash
ls -ld /home/elf/myansible
```

應該要看到像這樣：

```
drwxr-xr-x 10 elf elf 4096 Apr 13 21:50 /home/elf/myansible
```

（注意「沒有 w 在最右邊」）

---

### ✅ 再次執行確認：

```bash
ansible --version
```

應該會變成：

```
config file = /home/elf/myansible/ansible.cfg
```


# 有失敗要移除 PostgreSQL 17 的話，請執行以下指令：

```bash
# 1. 停止 PostgreSQL 服務（支援 systemd 兩種格式）
systemctl stop postgresql@17-main || systemctl stop postgresql-17

# 2. 完整移除 PostgreSQL 套件
apt purge -y postgresql-17 postgresql-client-17
apt autoremove -y

# 3. 刪除資料目錄與設定檔
rm -rf /var/lib/postgresql/17/main
rm -rf /etc/postgresql
rm -rf /var/log/postgresql

# 4. 移除 PostgreSQL 倉庫與金鑰
rm -f /etc/apt/sources.list.d/*pgdg*.list
rm -f /etc/apt/keyrings/postgresql.gpg
rm -f /usr/share/keyrings/postgresql.gpg

# 5. 清理快取並重新整理
apt clean && apt update
```