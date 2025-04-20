# ====== myansible Makefile ======
include .env
export

# 指令主入口
.DEFAULT_GOAL := help

#  ping 所有主機
ping:
	ansible-playbook -i $(INVENTORY) playbooks/tools/ping.yml

# 推送 SSH 金鑰
pg_ssh:
	ansible-playbook -i $(INVENTORY) playbooks/tools/pg_ssh.yml --extra-vars "ssh_user=postgres"

# 推送 root金鑰	
root_key:
	ansible-playbook -i $(INVENTORY) playbooks/tools/root_key.yml

# 清除 log
clean-log:
	@echo "清除 logs/ansible.log..."
	rm -f $(LOG_PATH)

# 模組化佈署
web:
	ansible-playbook -i $(INVENTORY) playbooks/web.yml

pg:
	ansible-playbook -i $(INVENTORY) playbooks/pg.yml

pg_backup:
	ansible-playbook -i $(INVENTORY) playbooks/tools/pg_backup.yml

staging:
	ansible-playbook -i inventories/staging/hosts playbooks/site-staging.yml

prod:
	ansible-playbook -i inventories/production/hosts playbooks/site-prod.yml

deploy:
	ansible-playbook -i $(INVENTORY) playbooks/site.yml

#  執行任意 Playbook
run:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK)

# 專案結構
tree:
	tree -a -I ".git|__pycache__|*.pyc"

# 修正檔案權限：只讓 .sh 腳本變成可執行
fix-perms:
	@echo "設定所有 .sh 腳本為可執行..."
	find . -type f -name "*.sh" -exec chmod +x {} \;
	@echo "權限設定完成：所有 .sh 腳本已加上執行權限"

# 🆘 指令說明
help:
	@echo "  myansible 指令一覽："
	@echo "  make ping         - 測試主機是否通"
	@echo "  make pg_ssh       - 設定 PostgreSQL 節點免密登入"
	@echo "  make pg_backup    - 備份 PostgreSQL 資料庫"
	@echo "  make clean-log    - 清除 logs 內 log 檔"
	@echo "  make tree         - 顯示專案結構"
	@echo "  make web          - 部署 Nginx"
	@echo "  make pg           - 部署 PostgreSQL 主從"
	@echo "  make staging      - 佈署測試環境"
	@echo "  make prod         - 佈署正式環境"
	@echo "  make deploy       - 佈署全部模組"
	@echo "  make run PLAYBOOK=xxx.yml - 自由執行任意 Playbook"
	@echo "  make fix-perms    - 修正檔案權限：只讓 .sh 腳本變成可執行"
