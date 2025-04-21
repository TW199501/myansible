#!/bin/bash

# PostgreSQL 自動備份腳本

# === 基本參數 ===
PG_USER="postgres"
BACKUP_BASE="/var/backups/postgresql"
DATE=$(date +"%Y-%m-%d")
RETENTION_DAYS=7                    # 備份保留天數
DB_LIST=({{ postgresql_backup_dbs | join(" ") }})           

# === 建立備份資料夾 ===
BACKUP_DIR="$BACKUP_BASE/$DATE"
mkdir -p "$BACKUP_DIR"

echo "備份路徑：$BACKUP_DIR"
echo "時間：$DATE"
echo "備份資料庫：${DB_LIST[*]}"

# === 開始備份 ===
for DB in "${DB_LIST[@]}"; do
    FILE="$BACKUP_DIR/${DB}.sql.gz"
    echo "備份 $DB..."
    pg_dump -U "$PG_USER" "$DB" | gzip > "$FILE"
    if [[ $? -eq 0 ]]; then
        echo "備份完成：$FILE"
    else
        echo "備份失敗：$DB"
    fi
done

# === 清理舊備份 ===
echo " 清理 $RETENTION_DAYS 天前的備份..."
find "$BACKUP_BASE" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;

echo " 所有備份任務完成。"
