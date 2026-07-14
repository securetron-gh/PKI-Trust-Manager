#!/usr/bin/env bash
# =============================================================================
# PKI Trust Manager — Automated Deployment Script
# =============================================================================
# Usage:
#   chmod +x deploy-pki-trust-manager.sh
#   sudo ./deploy-pki-trust-manager.sh
#
# What it does:
#   1. Checks/installs Docker + Docker Compose
#   2. Creates /opt/pki-trust-manager directory structure
#   3. Generates self-signed TLS certificates for Nginx
#   4. Creates .env with safe defaults (customize before production!)
#   5. Writes docker-compose.deploy.yml and nginx.minimal.conf
#   6. Pulls all container images
#   7. Deploys the full stack
#   8. Shows container status, resource usage, and access points
# =============================================================================

set -euo pipefail

# ---- Color helpers ----------------------------------------------------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
BOLD='\033[1m'; NC='\033[0m'
info()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
err()   { echo -e "${RED}[✗]${NC} $*" >&2; }
header(){ echo -e "\n${CYAN}══════════════════════════════════════════════════════${NC}"; }
step()  { echo -e "\n${BOLD}── $*${NC}"; }

# ---- Bail if not root -------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
  err "This script must be run as root (sudo ./deploy-pki-trust-manager.sh)"
  exit 1
fi

DEPLOY_DIR="/opt/pki-trust-manager"
SNAP_COMPAT_DIR=""

# Detect if Docker is installed via Snap (which has filesystem confinement)
if snap list docker &>/dev/null; then
  SNAP_COMPAT_DIR="/home/${SUDO_USER:-root}/ptm-deploy"
  warn "Docker is installed via Snap — will deploy under $SNAP_COMPAT_DIR (snap-accessible path)"
  warn "A symlink will be created at /opt/pki-trust-manager pointing to $SNAP_COMPAT_DIR"
  DEPLOY_DIR="$SNAP_COMPAT_DIR"
fi

# =============================================================================
# 1. Install Docker + Docker Compose (if missing)
# =============================================================================
header
echo -e "${CYAN}PKI Trust Manager — Automated Deployment${NC}"
header

step "1/8 — Checking / installing Docker"

if command -v docker &>/dev/null; then
  info "Docker already installed: $(docker --version 2>/dev/null)"
else
  warn "Docker not found — installing via get.docker.com ..."
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  info "Docker installed: $(docker --version)"
fi

if docker compose version &>/dev/null; then
  info "Docker Compose already installed: $(docker compose version 2>/dev/null)"
else
  warn "Installing docker-compose-plugin ..."
  apt-get update -qq && apt-get install -y -qq docker-compose-plugin
  info "Docker Compose installed: $(docker compose version)"
fi

# Ensure docker group exists and current (non-root) user is added
if ! getent group docker &>/dev/null; then
  groupadd docker
fi
if [[ -n "${SUDO_USER:-}" ]]; then
  usermod -aG docker "$SUDO_USER"
  info "User '$SUDO_USER' added to docker group (re-login to use docker without sudo)"
fi

# =============================================================================
# 2. Create directory structure
# =============================================================================
step "2/8 — Creating directory structure at $DEPLOY_DIR"

mkdir -p "$DEPLOY_DIR"/{certs,license,logs/{cmsweb,certapi,caapi,certexpired},config}
# Ensure the deploy dir is accessible
chmod 755 "$DEPLOY_DIR"
info "Directories created"

# =============================================================================
# 3. Generate self-signed TLS certificates for Nginx
# =============================================================================
step "3/8 — Generating self-signed TLS certificates"

cd "$DEPLOY_DIR/certs"
openssl genrsa -out key.pem 2048 2>/dev/null
openssl req -new -x509 -key key.pem -out cert.crt -days 365 \
  -subj "/C=US/ST=State/L=City/O=PKI-Trust-Manager/CN=*.local" 2>/dev/null
chmod 600 key.pem
chmod 644 cert.crt
info "Certificates created: cert.crt + key.pem (valid 365 days, self-signed)"
cd "$DEPLOY_DIR"

# =============================================================================
# 4. Create .env file with safe defaults
# =============================================================================
step "4/8 — Creating .env configuration file"

# ---- Interactive SQL Server setup prompt ------------------------------------
echo ""
echo -e "${BOLD}SQL Server Configuration${NC}"
echo ""
echo "  1) Deploy built-in SQL Server container (default)"
echo "  2) Connect to an external SQL Server (Enterprise)"
echo ""
read -p "  Choose [1/2]: " sql_choice

SQL_USE_EXTERNAL="false"
SQL_HOST="sqlserver.local"
SQL_USER="sa"

if [[ "$sql_choice" == "2" ]]; then
  SQL_USE_EXTERNAL="true"
  echo ""
  read -p "  Enter SQL Server host / IP / FQDN: " SQL_HOST
  read -p "  Enter SQL username [sa]: " tmp_user
  SQL_USER="${tmp_user:-sa}"
  read -s -p "  Enter SQL password: " SQL_SA_PASSWORD
  echo ""
  echo ""
  info "External SQL Server configured — will skip sqlserver container"
fi

# -----------------------------------------------------------------------------

cat > "$DEPLOY_DIR/.env" << 'ENVEOF'
# ============================================
# PKI Trust Manager - Environment Variables
# ============================================
CAAPI_TAG=latest
CERTAPI_TAG=latest
PKIMAIN_TAG=latest
AGENT_TAG=latest
CERTEXPIRED_TAG=latest

# SQL Server
SQL_SA_PASSWORD=PKI_Strong@Pass123
SQL_PORT=1433
SQL_DATABASE=PKIDBEE

# External SQL Server (set SQL_USE_EXTERNAL=true and SQL_HOST/IP/FQDN to use an existing SQL Server instead of deploying a container)
SQL_USE_EXTERNAL=false
SQL_HOST=sqlserver.local
SQL_USER=sa

# Service Ports
CAAPI_PORT=5051
CERTAPI_PORT=5052
CERTAPI_TLS_PORT=7103
CMSWEB_PORT=5053

# Nginx Protocol Ports
NGINX_EST_CLOUD_PORT=7030
NGINX_EST_LOCAL_PORT=7031
NGINX_SCEP_HTTP_PORT=8894
NGINX_SCEP_LOCAL_PORT=8895
NGINX_SCEP_HTTPS_PORT=8943
NGINX_ACME_CLOUD_PORT=8555
NGINX_ACME_LOCAL_PORT=8556
NGINX_HTTPS_PORT=443

# Admin User (CHANGE THESE IN PRODUCTION)
ADMIN_USERNAME=superadmin
ADMIN_PASSWORD=happy
ADMIN_EMAIL=root@local

# SMTP (REQUIRED for email notifications — replace with real values)
SMTP_SERVER=mail.smtp2go.com
SMTP_PORT=2525
SMTP_AUTH=true
SMTP_SSL=true
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
SMTP_SENDER_NAME=PKI
SMTP_SENDER=noreply@yourdomain.com
EMAIL_VERIFICATION=true

# Licensing (offline mode — place license.bin in ./license/)
LICENSE_FILE_PATH=/app/license/license.bin
LICENSE_OFFLINE_MODE=true
LICENSE_ONLINE_VALIDATION=false
LICENSE_PUBLIC_KEY=your_base64_encoded_public_key_here
LICENSE_SERVER_URL=http://localhost:7001
LICENSE_API_KEY=your_license_api_key_here
CMSWEB_CLIENT_ID=webcore-001
CERTAPI_CLIENT_ID=certapi-001

# API Provider Configuration (for hybrid mode)
CERTAPI_INTERNAL_URL=http://localhost:60713
CERTAPI_APP_ID=084a72b6-11d7-4e82-af11-bae943fea0a5
CERTAPI_APP_KEY=9d4e0346-2a4c-407b-bdf5-699bb68a5b61
CERTAPI_URL=http://localhost:60713
CMSWEB_APP_ID=b74ad6d9-6418-407a-b36e-69613d35517a
CMSWEB_APP_KEY=70803d70-3d0f-47fd-a206-cff4d0c15777
CERTAPI_AGENT_URL=http://localhost:5052/local
AGENT_APP_ID=084a72b6-11d7-4e82-af11-bae943fea0a5
AGENT_APP_KEY=9d4e0346-2a4c-407b-bdf5-699bb68a5b61

# ACME / SCEP
ACME_REUSE_VALIDATION=false
ACME_ORDER_VALIDITY=60
SCEP_OTP_VALIDITY=525600

# Certificate Expiry Notification
EXPIRY_START_RANGE=30
EXPIRY_END_RANGE=1
EXPIRY_NOTIFY_INTERVAL=1
EXPIRY_SCAN_INTERVAL=1440

# Authentication
LOGIN_VALIDITY=15
OTP_NAME=Securetron-PKI

# Environment
ENV_MODE=Cloud
TRUST_LEVEL=Private

# Logging
LOG_LEVEL=Debug
LOG_LEVEL_MS=Warning

# Cloud/External
CLOUD_IP=192.168.20.1

# Data Migration
Environment_CanMigrateData=true
ENVEOF

chmod 600 "$DEPLOY_DIR/.env"
info ".env created with defaults ($DEPLOY_DIR/.env)"

# If the user chose external SQL, update the .env values
if [[ "$SQL_USE_EXTERNAL" == "true" ]]; then
  sed -i "s/^SQL_USE_EXTERNAL=.*$/SQL_USE_EXTERNAL=true/" "$DEPLOY_DIR/.env"
  sed -i "s|^SQL_HOST=.*$|SQL_HOST=${SQL_HOST}|" "$DEPLOY_DIR/.env"
  sed -i "s/^SQL_USER=.*$/SQL_USER=${SQL_USER}/" "$DEPLOY_DIR/.env"
  sed -i "s|^SQL_SA_PASSWORD=.*$|SQL_SA_PASSWORD=${SQL_SA_PASSWORD}|" "$DEPLOY_DIR/.env"
  info "External SQL configured: host=${SQL_HOST}, user=${SQL_USER}"
fi

# Source .env so script-level decisions (e.g. external SQL) are available
set -a
source "$DEPLOY_DIR/.env"
set +a

# =============================================================================
# 5. Write docker-compose.deploy.yml
# =============================================================================
step "5/8 — Writing deployment compose file"

cat > "$DEPLOY_DIR/docker-compose.deploy.yml" << 'COMPOSEEOF'
version: '3.8'

networks:
  access-bridge:
    driver: bridge
  application-bridge:
    driver: bridge

volumes:
  sqlserver-data:

services:
  # -------------------------------------------------------
  # SQL Server - Main Database
  # -------------------------------------------------------
  sqlserver:
    hostname: sqlserver.local
    container_name: sqlserver
    image: mcr.microsoft.com/mssql/server:2022-latest
    environment:
      MSSQL_SA_PASSWORD: ${SQL_SA_PASSWORD:-PKI_Strong@Pass123}
      ACCEPT_EULA: "Y"
    networks:
      - application-bridge
    ports:
      - "${SQL_PORT:-1433}:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P ${SQL_SA_PASSWORD:-PKI_Strong@Pass123} -Q 'SELECT 1' -C"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  # -------------------------------------------------------
  # CA API - CA Proxy
  # -------------------------------------------------------
  caapi:
    hostname: caapi.local
    container_name: caapi
    image: securetron.azurecr.io/caapiee:${CAAPI_TAG:-latest}
    networks:
      - application-bridge
    ports:
      - "${CAAPI_PORT:-5051}:5225"
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - CASettings__CAType=EJBCA
      - CASettings__EjbcaSoapUrlOrAwsCaArn=https://ejbca.local:8443/ejbca/ejbcaws/ejbcaws?wsdl
      - CASettings__EjbcaCaNameOrAwsAccessKey=${EJBCA_CA_NAME:-ManagementCA}
      - CASettings__EjbcaCertAuthPasswordOrAwsSecretKey=${EJBCA_CA_PASSWORD:-ejbca}
      - Logging__LogLevel__Default=${LOG_LEVEL:-Information}
      - Logging__LogLevel__Microsoft=${LOG_LEVEL_MS:-Warning}
    restart: always

  # -------------------------------------------------------
  # Certificate API - ACME, SCEP, REST
  # -------------------------------------------------------
  certapi:
    hostname: certapi.local
    container_name: certapi
    image: securetron.azurecr.io/certapiee:${CERTAPI_TAG:-latest}
    depends_on:
      caapi:
        condition: service_started
      sqlserver:
        condition: service_healthy
    networks:
      - access-bridge
      - application-bridge
    ports:
      - "${CERTAPI_PORT:-5052}:5227"
      - "${CERTAPI_TLS_PORT:-7103}:7103"
    volumes:
      - ./license:/app/license:ro
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__OurDBContext=Server=${SQL_HOST:-sqlserver.local},${SQL_PORT:-1433};Database=${SQL_DATABASE:-PKIDBEE};User Id=${SQL_USER:-sa};Password=${SQL_SA_PASSWORD:-PKI_Strong@Pass123};MultipleActiveResultSets=true;TrustServerCertificate=True;
      - APIProvider__BaseUrl=${CERTAPI_INTERNAL_URL:-http://localhost:60713}
      - APIProvider__AppId=${CERTAPI_APP_ID:-084a72b6-11d7-4e82-af11-bae943fea0a5}
      - APIProvider__AppKey=${CERTAPI_APP_KEY:-9d4e0346-2a4c-407b-bdf5-699bb68a5b61}
      - Acme__ReuseDomainValidation=${ACME_REUSE_VALIDATION:-false}
      - Acme__PendingOrderValidityMinutes=${ACME_ORDER_VALIDITY:-60}
      - Scep__OtpValidityMinutes=${SCEP_OTP_VALIDITY:-60}
      - Smtp__Server=${SMTP_SERVER:-mail.smtp2go.com}
      - Smtp__Port=${SMTP_PORT:-2525}
      - Smtp__Auth=${SMTP_AUTH:-true}
      - Smtp__EnableSsl=${SMTP_SSL:-true}
      - Smtp__Username=${SMTP_USERNAME}
      - Smtp__Password=${SMTP_PASSWORD}
      - Smtp__SenderName=${SMTP_SENDER_NAME:-PKI}
      - Smtp__SenderAddress=${SMTP_SENDER:-noreply@yourdomain.com}
      - Licensing__ServerUrl=${LICENSE_SERVER_URL:-http://localhost:7001}
      - Licensing__ApiKey=${LICENSE_API_KEY}
      - Licensing__ClientId=${CERTAPI_CLIENT_ID:-certapi-001}
      - Licensing__OfflineMode=${LICENSE_OFFLINE_MODE:-true}
      - Licensing__EnableOnlineValidation=${LICENSE_ONLINE_VALIDATION:-false}
      - Licensing__PublicKey=${LICENSE_PUBLIC_KEY}
      - Logging__LogLevel__Default=${LOG_LEVEL:-Information}
      - Logging__LogLevel__Microsoft=${LOG_LEVEL_MS:-Warning}
    restart: always
    extra_hosts:
      - "certapi.cloud:${CLOUD_IP:-192.168.20.1}"

  # -------------------------------------------------------
  # Web UI - Certificate Management Portal
  # -------------------------------------------------------
  cmsweb:
    hostname: cmsweb.local
    container_name: cmsweb
    image: securetron.azurecr.io/pkimain:${PKIMAIN_TAG:-latest}
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - access-bridge
      - application-bridge
    ports:
      - "${CMSWEB_PORT:-5053}:5228"
    volumes:
      - ./license:/app/license:ro
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__OurDBContext=Server=${SQL_HOST:-sqlserver.local},${SQL_PORT:-1433};Database=${SQL_DATABASE:-PKIDBEE};User Id=${SQL_USER:-sa};Password=${SQL_SA_PASSWORD:-PKI_Strong@Pass123};MultipleActiveResultSets=true;TrustServerCertificate=True;
      - Environment__Mode=${ENV_MODE:-Cloud}
      - Environment__TrustLevel=${TRUST_LEVEL:-Public}
      - APIProvider__BaseUrl=${CERTAPI_URL:-http://localhost:60713}
      - APIProvider__AppId=${CMSWEB_APP_ID:-b74ad6d9-6418-407a-b36e-69613d35517a}
      - APIProvider__AppKey=${CMSWEB_APP_KEY:-70803d70-3d0f-47fd-a206-cff4d0c15777}
      - Authentication__DefaultSuperAdminUsername=${ADMIN_USERNAME:-superadmin}
      - Authentication__DefaultSuperAdminPassword=${ADMIN_PASSWORD:-happy}
      - Authentication__DefaultSuperAdminEmail=${ADMIN_EMAIL:-root@local}
      - Authentication__LoginSessionValidityInMinutes=${LOGIN_VALIDITY:-15}
      - Authentication__AppOtpName=${OTP_NAME:-PKIDev}
      - Email__RequireVerification=${EMAIL_VERIFICATION:-true}
      - Smtp__Server=${SMTP_SERVER:-mail.smtp2go.com}
      - Smtp__Port=${SMTP_PORT:-2525}
      - Smtp__Auth=${SMTP_AUTH:-true}
      - Smtp__EnableSsl=${SMTP_SSL:-true}
      - Smtp__Username=${SMTP_USERNAME}
      - Smtp__Password=${SMTP_PASSWORD}
      - Smtp__SenderName=${SMTP_SENDER_NAME:-PKI}
      - Smtp__SenderAddress=${SMTP_SENDER:-noreply@yourdomain.com}
      - CertExpiryNotificationPeriod__StartScanningRangeInXdays=${EXPIRY_START_RANGE:-3}
      - CertExpiryNotificationPeriod__EndScanningRangeInXdays=${EXPIRY_END_RANGE:-3}
      - CertExpiryNotificationPeriod__SendingNotificationEveryXdays=${EXPIRY_NOTIFY_INTERVAL:-1}
      - CertExpiryNotificationPeriod__ScanningIntervalEveryXminutes=${EXPIRY_SCAN_INTERVAL:-30}
      - Scep__OtpValidityMinutes=${SCEP_OTP_VALIDITY:-60}
      - Licensing__ServerUrl=${LICENSE_SERVER_URL:-http://localhost:7001}
      - Licensing__ApiKey=${LICENSE_API_KEY}
      - Licensing__ClientId=${CMSWEB_CLIENT_ID:-webcore-001}
      - Licensing__OfflineMode=${LICENSE_OFFLINE_MODE:-true}
      - Licensing__EnableOnlineValidation=${LICENSE_ONLINE_VALIDATION:-false}
      - Licensing__PublicKey=${LICENSE_PUBLIC_KEY}
      - Logging__LogLevel__Default=${LOG_LEVEL:-Information}
      - Logging__LogLevel__Microsoft=${LOG_LEVEL_MS:-Warning}
    restart: always

  # -------------------------------------------------------
  # Certificate Expiry Worker
  # -------------------------------------------------------
  certexpired:
    hostname: certexpired.local
    container_name: certexpired
    image: securetron.azurecr.io/certexpired:${CERTEXPIRED_TAG:-latest}
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - application-bridge
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__OurDBContext=Server=${SQL_HOST:-sqlserver.local},${SQL_PORT:-1433};Database=${SQL_DATABASE:-PKIDBEE};User Id=${SQL_USER:-sa};Password=${SQL_SA_PASSWORD:-PKI_Strong@Pass123};MultipleActiveResultSets=true;TrustServerCertificate=True;
      - Smtp__Server=${SMTP_SERVER:-mail.smtp2go.com}
      - Smtp__Port=${SMTP_PORT:-2525}
      - Smtp__Auth=${SMTP_AUTH:-true}
      - Smtp__EnableSsl=${SMTP_SSL:-true}
      - Smtp__Username=${SMTP_USERNAME}
      - Smtp__Password=${SMTP_PASSWORD}
      - Smtp__SenderName=${SMTP_SENDER_NAME:-PKI}
      - Smtp__SenderAddress=${SMTP_SENDER:-noreply@yourdomain.com}
      - CertExpiryNotificationPeriod__StartScanningRangeInXdays=${EXPIRY_START_RANGE:-3}
      - CertExpiryNotificationPeriod__EndScanningRangeInXdays=${EXPIRY_END_RANGE:-3}
      - CertExpiryNotificationPeriod__SendingNotificationEveryXdays=${EXPIRY_NOTIFY_INTERVAL:-1}
      - CertExpiryNotificationPeriod__ScanningIntervalEveryXminutes=${EXPIRY_SCAN_INTERVAL:-30}
      - Logging__LogLevel__Default=${LOG_LEVEL:-Information}
      - Logging__LogLevel__Microsoft=${LOG_LEVEL_MS:-Warning}
    restart: always

  # -------------------------------------------------------
  # Nginx - Reverse Proxy & SSL Termination
  # -------------------------------------------------------
  nginx:
    image: nginx:alpine
    container_name: nginx
    restart: always
    volumes:
      - ./nginx.minimal.conf:/etc/nginx/nginx.conf:ro
      - ./certs/cert.crt:/etc/nginx/cert.crt:ro
      - ./certs/key.pem:/etc/nginx/key.pem:ro
    ports:
      - "${NGINX_EST_CLOUD_PORT:-7030}:7030"
      - "${NGINX_EST_LOCAL_PORT:-7031}:7031"
      - "${NGINX_SCEP_HTTP_PORT:-8894}:8894"
      - "${NGINX_SCEP_LOCAL_PORT:-8895}:8895"
      - "${NGINX_SCEP_HTTPS_PORT:-8943}:8943"
      - "${NGINX_ACME_CLOUD_PORT:-8555}:8555"
      - "${NGINX_ACME_LOCAL_PORT:-8556}:8556"
      - "${NGINX_HTTPS_PORT:-443}:443"
    depends_on:
      - cmsweb
      - certapi
    networks:
      - access-bridge
      - application-bridge
COMPOSEEOF

info "docker-compose.deploy.yml written"

# If using external SQL, remove the built-in sqlserver service from compose
if [[ "$SQL_USE_EXTERNAL" == "true" ]]; then
  # Remove sqlserver service block (from comment to next section header)
  sed -i '/^  # SQL Server - Main Database/,/^  # CA API/{/^  # CA API/!d}' "$DEPLOY_DIR/docker-compose.deploy.yml"
  # Remove sqlserver depends_on ("      sqlserver:" + next line)
  sed -i '/^      sqlserver:/{N;d}' "$DEPLOY_DIR/docker-compose.deploy.yml"
  # Remove now-empty depends_on keys: delete "depends_on:" line but keep the next line
  sed -i '/^    depends_on:$/{N; /\n    [a-z]/{s/^    depends_on:\n//}}' "$DEPLOY_DIR/docker-compose.deploy.yml"
  info "External SQL configured — sqlserver container removed from compose"
fi

# =============================================================================
# 6. Write nginx.minimal.conf
# =============================================================================
step "6/8 — Writing Nginx configuration"

cat > "$DEPLOY_DIR/nginx.minimal.conf" << 'NGINXEOF'
events { worker_connections 1024; }

http {
    upstream local_certapi_apps {
        server certapi.local:5227 max_fails=3 fail_timeout=30s;
    }
    upstream local_cmsweb_apps {
        server cmsweb.local:5228 max_fails=3 fail_timeout=30s;
    }

    # EST Local
    server {
        listen 7031 ssl;
        server_name est.local;
        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        ssl_verify_client optional_no_ca;
        location / {
            proxy_pass http://local_certapi_apps;
            proxy_set_header Host $http_host;
            proxy_set_header Authorization $http_authorization;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Client-Cert $ssl_client_escaped_cert;
        }
    }

    # SCEP HTTP
    server {
        listen 8895;
        server_name scep.local;
        location / {
            proxy_pass http://local_certapi_apps;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

    # SCEP HTTPS
    server {
        listen 8896 ssl;
        server_name scep.local;
        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        location / {
            proxy_pass http://local_certapi_apps;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

    # ACME Local
    server {
        listen 8556 ssl;
        server_name acme.local;
        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        location / {
            proxy_pass http://local_certapi_apps;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

    # CertAPI via Nginx (port 443, cmsapi.local)
    server {
        listen 443 ssl;
        server_name cmsapi.local;
        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        location / {
            proxy_pass http://local_certapi_apps;
            proxy_set_header Host $http_host;
            proxy_set_header Authorization $http_authorization;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

    # Web UI via Nginx (port 443 default, cmsweb.local)
    server {
        listen 443 ssl default_server;
        server_name cmsweb.local;
        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        location / {
            proxy_pass http://local_cmsweb_apps;
            proxy_set_header Host $http_host;
            proxy_set_header Authorization $http_authorization;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
NGINXEOF

info "nginx.minimal.conf written"

# =============================================================================
# 7. Pull all container images
# =============================================================================
step "7/8 — Pulling container images"

IMAGES=(
  "mcr.microsoft.com/mssql/server:2022-latest"
  "securetron.azurecr.io/pkimain:latest"
  "securetron.azurecr.io/certapiee:latest"
  "securetron.azurecr.io/caapiee:latest"
  "securetron.azurecr.io/certexpired:latest"
  "nginx:alpine"
)

for img in "${IMAGES[@]}"; do
  # Skip SQL Server image when using an external database
  if [[ "$SQL_USE_EXTERNAL" == "true" && "$img" == *"mssql"* ]]; then
    info "Skipping $img (external SQL Server configured)"
    continue
  fi
  echo -n "  Pulling $img ... "
  if docker pull "$img" &>/dev/null; then
    echo -e "${GREEN}done${NC}"
  else
    echo -e "${RED}failed${NC}"
    err "Failed to pull $img — check internet connectivity"
    exit 1
  fi
done

info "All images pulled successfully"

# =============================================================================
# 8. Deploy the stack
# =============================================================================
step "8/8 — Deploying the stack"

cd "$DEPLOY_DIR"

# If we moved to snap-compat dir, create a symlink from the canonical path
if [[ -n "$SNAP_COMPAT_DIR" ]]; then
  ln -sfn "$SNAP_COMPAT_DIR" "/opt/pki-trust-manager"
  info "Symlink created: /opt/pki-trust-manager → $SNAP_COMPAT_DIR"
fi

# Stop & remove any previous containers (clean start)
docker compose -f docker-compose.deploy.yml --env-file .env down 2>/dev/null || true

# Start everything
docker compose -f docker-compose.deploy.yml --env-file .env up -d

echo ""
info "Deployment initiated. Waiting for services to stabilise..."
echo ""

# Wait for SQL Server health check (longer for first boot) — skip when using external DB
if [[ "$SQL_USE_EXTERNAL" != "true" ]]; then
  echo -n "  Waiting for SQL Server (up to 90s) ... "
  for i in $(seq 1 30); do
    if docker inspect sqlserver --format='{{.State.Health.Status}}' 2>/dev/null | grep -q healthy; then
      echo -e "${GREEN}healthy${NC}"
      break
    fi
    if [[ $i -eq 30 ]]; then
      echo -e "${YELLOW}timeout (check 'docker logs sqlserver')${NC}"
    else
      sleep 3
      echo -n "."
    fi
  done
fi

echo ""
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  PKI Trust Manager — Deployment Complete${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo ""

# ---- Container Status ----
echo -e "${BOLD}Container Status${NC}"
echo ""
docker compose -f docker-compose.deploy.yml ps 2>/dev/null | grep -v WARNING
echo ""

# ---- Resource Usage ----
echo -e "${BOLD}Resource Usage${NC}"
echo ""
MEM_TOTAL=$(free -h | awk '/^Mem:/{print $2}')
MEM_USED=$(free -h | awk '/^Mem:/{print $3}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
DISK_AVAIL=$(df -h / | awk 'NR==2{print $4}')
echo "  RAM:  $MEM_USED / $MEM_TOTAL"
echo "  Disk: $DISK_USED / $DISK_TOTAL (avail: $DISK_AVAIL)"
echo ""

# ---- Access Points ----
IP_ADDR=$(hostname -I | awk '{print $1}')
echo -e "${BOLD}Access Points${NC}"
echo ""
echo -e "  ${CYAN}Web Admin UI:${NC}       http://$IP_ADDR:5053/"
echo -e "  ${CYAN}Web Admin (SSL):${NC}    https://$IP_ADDR/"
echo -e "  ${CYAN}CertAPI Health:${NC}     http://$IP_ADDR:5052/health"
echo -e "  ${CYAN}CAAPI Health:${NC}       http://$IP_ADDR:5051/health"
echo -e "  ${CYAN}SCEP:${NC}               http://$IP_ADDR:8895/scep"
echo -e "  ${CYAN}ACME:${NC}               https://$IP_ADDR:8556/acme/directory"
echo -e "  ${CYAN}EST:${NC}                https://$IP_ADDR:7031/.well-known/est"
echo ""

# ---- Default Credentials ----
echo -e "${BOLD}Default Credentials${NC}"
echo ""
echo "  Username: superadmin"
echo "  Password: happy"
echo ""
echo -e "${YELLOW}⚠  IMPORTANT: Change the admin password and SMTP settings${NC}"
echo -e "${YELLOW}   in $DEPLOY_DIR/.env before going to production!${NC}"
echo ""

# ---- Next Steps ----
echo -e "${BOLD}Next Steps${NC}"
echo ""
echo "  1. Place license.bin → ${DEPLOY_DIR}/license/"
echo "  2. Set LICENSE_PUBLIC_KEY in ${DEPLOY_DIR}/.env"
echo "  3. Configure real SMTP credentials in ${DEPLOY_DIR}/.env"
echo "  4. Change default passwords (ADMIN_PASSWORD)"
echo "  5. Restart affected services:"
echo "     cd ${DEPLOY_DIR} && docker compose -f docker-compose.deploy.yml --env-file .env restart cmsweb certapi"
echo ""

echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo ""
