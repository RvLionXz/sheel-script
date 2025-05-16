#!/bin/bash

# === CONFIGURABLE VARIABLES ===
PGSQL_USER="myuser"
PGSQL_PASS="P@sW0rDKu@7!"
PGSQL_DB="db_test"
PGSQL_PORT=5432
ALLOWED_IP="0.0.0.0/0"

# === COLOR FOR ECHO ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === SCRIPT START ===

echo -e "${YELLOW}🔄 Updating package list...${NC}"
sudo apt update && echo -e "${GREEN}✔ Package list updated!${NC}" || { echo -e "${RED}✖ Failed to update packages.${NC}"; exit 1; }
sleep 2

echo -e "${YELLOW}📦 Installing PostgreSQL...${NC}"
sudo apt install -y postgresql postgresql-contrib && echo -e "${GREEN}✔ PostgreSQL installed!${NC}" || { echo -e "${RED}✖ Failed to install PostgreSQL.${NC}"; exit 1; }
sleep 2

echo -e "${RED}⛔ Stopping PostgreSQL service to apply configuration...${NC}"
sudo service postgresql stop
sleep 2

# Get PostgreSQL version directory (e.g. 12, 14, etc.)
PG_VERSION=$(ls /etc/postgresql)
PG_CONF="/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
PG_HBA="/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"

echo -e "${YELLOW}⚙ Configuring postgresql.conf...${NC}"
sudo sed -i "s/#port = 5432/port = ${PGSQL_PORT}/" "$PG_CONF"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" "$PG_CONF"
echo -e "${GREEN}✔ postgresql.conf updated!${NC}"
sleep 2

echo -e "${YELLOW}🔐 Configuring pg_hba.conf for remote access from ${ALLOWED_IP}...${NC}"
echo "host    all             all             ${ALLOWED_IP}             md5" | sudo tee -a "$PG_HBA" > /dev/null
echo -e "${GREEN}✔ pg_hba.conf updated!${NC}"
sleep 2

echo -e "${YELLOW}▶ Starting PostgreSQL service...${NC}"
sudo service postgresql start && echo -e "${GREEN}✔ PostgreSQL started!${NC}" || echo -e "${RED}✖ Failed to start PostgreSQL.${NC}"
sleep 2

echo -e "${YELLOW}🛠 Creating user and database...${NC}"
sudo -u postgres psql <<EOF
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${PGSQL_USER}') THEN
      CREATE USER ${PGSQL_USER} WITH PASSWORD '${PGSQL_PASS}';
   END IF;
END
\$\$;
CREATE DATABASE ${PGSQL_DB} OWNER ${PGSQL_USER};
EOF
echo -e "${GREEN}✔ User and database created!${NC}"
sleep 2

echo -e "${YELLOW}🔄 Restarting PostgreSQL to apply all changes...${NC}"
sudo service postgresql restart && echo -e "${GREEN}✔ PostgreSQL restarted successfully!${NC}" || echo -e "${RED}✖ Failed to restart PostgreSQL.${NC}"

# === FINAL MESSAGE ===
echo -e "${CYAN}"
echo "✅ PostgreSQL setup complete!"
echo "----------------------------------------"
echo "👤 User     : $PGSQL_USER"
echo "🔑 Password : $PGSQL_PASS"
echo "🗄  Database : $PGSQL_DB"
echo "🌐 Port     : $PGSQL_PORT"
echo "🌍 Remote   : $ALLOWED_IP"
echo "----------------------------------------"
echo -e "${NC}"
