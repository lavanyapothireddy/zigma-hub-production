#!/bin/bash
# ==========================================
# Zigma Hub — SSL Certificate Setup
# Run ONCE after DNS is pointed to server
# Usage: bash scripts/setup-ssl.sh hub.zigmaneural.com admin@zigmaneural.com
# ==========================================

set -e

DOMAIN=${1:-hub.zigmaneural.com}
EMAIL=${2:-admin@zigmaneural.com}

echo "🔒 Setting up SSL for $DOMAIN..."

# Make sure port 80 is accessible (stop nginx if running)
docker compose stop nginx 2>/dev/null || true

# Get certificate
sudo certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --email "$EMAIL" \
  -d "$DOMAIN"

# Update nginx config with correct domain
sed -i "s/hub.zigmaneural.com/$DOMAIN/g" nginx/zigma-hub.conf

# Start nginx back up
docker compose up -d nginx

echo "✅ SSL certificate installed for $DOMAIN"
echo "   Auto-renewal is handled by certbot.timer (systemd)"
