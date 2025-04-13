# ====== myansible Makefile ======
# make deploy        → 固定部署主流程
# make run PLAYBOOK=xxx.yml → 自由部署任意 Playbook

deploy:
	ansible-playbook -i $(INVENTORY) playbooks/site.yml

run:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK)

# 預設主機清單與目錄
INVENTORY ?= inventories/production/hosts
PLAYBOOK  ?= playbooks/ping_all.yml
SSH_PUSH  ?= tools/ssh_push.sh
LOG_PATH  ?= logs/ansible.log

# 預設指令（相當於 ping）
.DEFAULT_GOAL := ping

# 測試所有主機是否連通
ping:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK)

# 傳送 SSH 金鑰（使用 root，或改 USER=ubuntu）
ssh-push:
	@echo "📡 傳送 SSH 公鑰至受控主機中..."
	bash $(SSH_PUSH) root

# 清除 ansible log
clean-log:
	@echo "🧹 清除 logs/ansible.log..."
	rm -f $(LOG_PATH)

# 按tag佈署
web:
	ansible-playbook -i $(INVENTORY) playbooks/web.yml

db:
	ansible-playbook -i $(INVENTORY) playbooks/db.yml

staging:
	ansible-playbook -i inventories/staging/hosts playbooks/site-staging.yml

prod:
	ansible-playbook -i inventories/production/hosts playbooks/site-prod.yml

# 全部佈署
deploy:
	ansible-playbook -i $(INVENTORY) playbooks/site.yml


# 📂 顯示目前專案結構
tree:
	tree -a -I ".git|__pycache__|*.pyc"

# 🆘 說明文件
help:
	@echo "  myansible 指令一覽："
	@echo "  make ping         - 測試主機是否通"
	@echo "  make deploy       - 佈署主機（可自定 site.yml）"
	@echo "  make ssh-push     - 設定免密登入（預設 root）"
	@echo "  make clean-log    - 清除 logs 內 log 檔"
	@echo "  make tree         - 顯示專案結構"
	@echo "  make web          - 部署 Nginx"
	@echo "  make db           - 部署 PostgreSQL 主從"
	@echo "  make staging      - 佈署測試環境"
	@echo "  make prod         - 佈署正式環境"
	@echo "  make deploy       - 佈署全部模組"
.DEFAULT_GOAL := help



