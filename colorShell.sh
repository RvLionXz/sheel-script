#!/bin/bash

# Definisi warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

# Menampilkan teks berwarna
echo -e "${YELLOW}Menjalankan perintah: ${RED}sudo apt update${NC}"
sudo apt update
