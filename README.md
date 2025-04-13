
# myansible

Ansible 自動化專案，使用最佳實務架構，支援多環境（production / staging）、模組化角色與免密 SSH 快速佈署。

## 專案結構簡介
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
