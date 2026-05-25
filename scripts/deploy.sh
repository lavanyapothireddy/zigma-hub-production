#!/bin/bash
# ==========================================
# Zigma Hub — Deployment Script
# Run: bash scripts/deploy.sh
# ==========================================

set -e

echo "🚀 Starting Zigma Hub deployment..."

# Check .env exists
if [ ! -f .env ]; then
  echo "❌ ERROR: .env file not found!"
  echo "   Copy .env.example to .env and fill in values first."
  exit 1
fi

# Create data directories
echo "📁 Creating data directories..."
sudo mkdir -p /data/postgres /data/redis /data/storage /data/certbot/www
sudo chown -R $USER:$USER /data

# Pull latest images
echo "📦 Pulling Docker images..."
docker compose pull

# Run DB migrations
echo "🗄️  Running database migrations..."
docker compose run --rm rails bundle exec rails db:chatwoot_prepare

# Start all services
echo "▶️  Starting services..."
docker compose up -d

# Wait for rails to be ready
echo "⏳ Waiting for app to start..."
sleep 15

# Health check
if curl -sf http://localhost:3000/auth/sign_in > /dev/null; then
  echo "✅ Zigma Hub is running at http://localhost:3000"
else
  echo "⚠️  App may still be starting. Check logs: docker compose logs rails"
fi

echo ""
echo "📋 Useful commands:"
echo "  docker compose logs -f rails     # View app logs"
echo "  docker compose logs -f sidekiq   # View background jobs"
echo "  docker compose ps                # Check service status"
echo "  docker compose down              # Stop all services"
