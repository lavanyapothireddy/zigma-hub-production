# Zigma Hub — Internal Support Platform

Internal employee support hub for **Zigma Neural**, built on Chatwoot v4.10.1 with custom extensions.

## Features
- Omnichannel inbox (Email, WhatsApp, Chat)
- Zigma AI Assistant (Claude API)
- SLA-based ticket escalation
- Metabase analytics dashboards
- Jitsi Meet video integration
- SSO / SAML login (Google Workspace / Azure AD)
- Custom Zigma Neural branding

## Quick Start

### 1. Clone & configure
```bash
git clone https://github.com/VardhiY/zigma-hub.git
cd zigma-hub
cp .env.example .env
# Edit .env with your values
nano .env
```

### 2. Deploy
```bash
bash scripts/deploy.sh
```

### 3. Set up SSL (after DNS is pointed to server)
```bash
bash scripts/setup-ssl.sh hub.zigmaneural.com admin@zigmaneural.com
```

## File Structure
```
zigma-hub/
├── docker-compose.yml        # All services
├── .env.example              # Config template (copy to .env)
├── nginx/
│   └── zigma-hub.conf        # Nginx reverse proxy + SSL
├── scripts/
│   ├── deploy.sh             # One-command deploy
│   ├── setup-ssl.sh          # SSL certificate setup
│   └── backup.sh             # Daily DB + storage backup
├── docker/
│   └── fail2ban-jail.conf    # Brute-force protection
└── .github/
    └── workflows/deploy.yml  # Auto-deploy on push to main
```

## Services
| Service    | Port  | Description              |
|------------|-------|--------------------------|
| rails      | 3000  | Main app (internal only) |
| sidekiq    | —     | Background jobs          |
| postgres   | 5432  | Database (internal only) |
| redis      | 6379  | Cache/queue (internal)   |
| nginx      | 80/443| Public reverse proxy     |

## Useful Commands
```bash
docker compose logs -f rails       # App logs
docker compose logs -f sidekiq     # Background job logs
docker compose ps                  # Service status
docker compose down                # Stop everything
bash scripts/backup.sh             # Manual backup
```

## Deployment Roadmap
- [x] Phase 1 — Foundation (Docker, Nginx, SSL, Email)
- [ ] Phase 2 — Employee features (directory, shift scheduler, knowledge base)
- [ ] Phase 3 — AI & analytics (Claude bot, Metabase, SLA rules)
- [ ] Phase 4 — Security & scale (encryption, Jitsi, load testing)
