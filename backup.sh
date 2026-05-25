#!/bin/bash
# ==========================================
# Zigma Hub — Backup Script
# Cron: 0 2 * * * bash /home/ubuntu/zigma-hub/scripts/backup.sh
# ==========================================

set -e

BACKUP_DIR="/data/backups"
DATE=$(date +%Y%m%d_%H%M%S)
source .env

echo "💾 Starting backup: $DATE"
mkdir -p "$BACKUP_DIR"

# Backup PostgreSQL
echo "  → Backing up database..."
docker compose exec -T postgres pg_dump \
  -U "$POSTGRES_USERNAME" "$POSTGRES_DATABASE" \
  | gzip > "$BACKUP_DIR/db_$DATE.sql.gz"

# Backup file storage
echo "  → Backing up uploaded files..."
tar -czf "$BACKUP_DIR/storage_$DATE.tar.gz" /data/storage

# Delete backups older than 7 days
echo "  → Cleaning old backups..."
find "$BACKUP_DIR" -name "*.gz" -mtime +7 -delete

echo "✅ Backup complete: $BACKUP_DIR"
ls -lh "$BACKUP_DIR" | tail -5
