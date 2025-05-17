#!/bin/bash

# === CONFIGURABLE VARIABLES ===
DOMAIN="example.com"            # Ganti dengan domain
EMAIL="aaaaaa@gmail.com"       # Ganti dengan email yang valid

# === COLOR FOR ECHO ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === SCRIPT START ===

echo -e "${YELLOW}📦 Installing Certbot and Let's Encrypt for Nginx...${NC}"
# Menginstal certbot dan plugin untuk Nginx
sudo apt install -y certbot python3-certbot-nginx && echo -e "${GREEN}✔ Certbot installed!${NC}" || {
    echo -e "${RED}✖ Failed to install Certbot.${NC}"
    exit 1
}
sleep 3

echo -e "${YELLOW}🌐 Requesting SSL certificate for domain: ${DOMAIN}${NC}"
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL && echo -e "${GREEN}✔ SSL certificate installed for ${DOMAIN}!${NC}" || {
    echo -e "${RED}✖ Failed to install SSL certificate.${NC}"
    exit 1
}
sleep 3

echo -e "${YELLOW}🔁 Enabling automatic certificate renewal...${NC}"
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
echo -e "${GREEN}✔ Auto-renewal timer is active!${NC}"
sleep 2

echo -e "${YELLOW}🔎 Testing auto-renewal process with --dry-run...${NC}"
sudo certbot renew --dry-run && echo -e "${GREEN}✔ Auto-renewal test passed!${NC}" || echo -e "${RED}✖ Auto-renewal test failed.${NC}"

# === FINAL MESSAGE ===
echo -e "${CYAN}"
echo "✅ Let's Encrypt SSL Setup Complete!"
echo "----------------------------------------"
echo "🌐 Domain    : $DOMAIN"
echo "📧 Email     : $EMAIL"
echo "🔒 Certbot   : Installed & Configured"
echo "♻  Auto-Renew: Enabled"
echo "----------------------------------------"
echo -e "${NC}"
