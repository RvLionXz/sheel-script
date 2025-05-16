#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${YELLOW}Updating Package..${NC}"
sudo apt update

echo "Installing Node.js.."
sudo apt install nodejs npm -y

echo "Cek Version.."
node --version
npm --version
