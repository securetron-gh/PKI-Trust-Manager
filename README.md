# PKI-Trust-Manager
Next Generation PKI Trust Manager simplifies certificate management including TLS, PQC, ADCS / MS CA, AWS CA, Azure Vault, and many more. The built in Smart Certificate Discovery and Advance Notification service ensures provides governance and the automation via SCEP, EST, as well as ACME prevents outages by automating renewal process.

# PKI Trust Manager Deployment Guide on Docker

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Architecture Overview](#architecture-overview)
4. [Setup Instructions](#setup-instructions)
5. [Configuration](#configuration)
6. [Environment Variables](#environment-variables)
7. [Nginx Configuration](#nginx-configuration)
8. [License Setup](#license-setup)
9. [Deployment Steps](#deployment-steps)
10. [Verification & Testing](#verification--testing)
11. [Troubleshooting](#troubleshooting)
12. [Maintenance](#maintenance)

## Prerequisites

### Software Requirements
- **Docker Engine** 20.10.0 or higher
- **Docker Compose** 2.0.0 or higher
- **Git** for version control
- **SSL/TLS certificates** (for production deployment)

### Access Requirements
- Docker Hub/Registry access for pulling images
- SQL Server client tools (optional, for database management)
- Administrative access to the deployment server

### Network Requirements
- Open ports: 1433 (SQL), 5053 (Web UI), 443 (HTTPS)
- Outbound SMTP access (port 2525 or your SMTP port)
- DNS resolution for service hostnames

## System Requirements

### Minimum Hardware
- **CPU**: 4 cores (x64 architecture)
- **RAM**: 8 GB minimum, 16 GB recommended
- **Storage**: 50 GB free disk space (SSD recommended)
- **Network**: 1 Gbps network interface

### Recommended Production Specs
- **CPU**: 8+ cores
- **RAM**: 32 GB
- **Storage**: 200 GB+ with RAID configuration
- **Backup**: Regular backup strategy for volumes

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PKI Trust Manager Stack                   │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Nginx Proxy   │   Web UI (CMS)  │      SQL Server         │
│   (SSL/TLS)     │   Port: 5228    │      Port: 1433        │
│   Port: 443     │                 │                         │
└─────────────────┴─────────────────┴─────────────────────────┘
           │                │                  │
           └────────────────┼──────────────────┘
                            │
                    Application Bridge Network
```

## Setup Instructions

### 1. Clone/Prepare Deployment Directory
```bash
mkdir -p /opt/pki-trust-manager
cd /opt/pki-trust-manager
```

### 2. Create Directory Structure
```bash
mkdir -p {certs,license,config}
```

### 3. Create Docker Compose File
Create `docker-compose.yaml` with the provided configuration:
```bash
cat > docker-compose.yaml << 'EOF'
[PASTE THE PROVIDED DOCKER-COMPOSE.YAML CONTENT HERE]
EOF
```

### 4. Create Environment File
Create `.env` file for environment variables:
```bash
cat > .env << 'EOF'
# Database Configuration
SQL_SA_PASSWORD=YourStrong@Password123
SQL_DATABASE=PKIDBEE
SQL_PORT=1433

# Web Application
PKIMAIN_TAG=latest
CMSWEB_PORT=5053
ENV_MODE=Cloud
TRUST_LEVEL=Public

# Admin Configuration
ADMIN_USERNAME=superadmin
ADMIN_PASSWORD=YourAdminPass123!
ADMIN_EMAIL=admin@yourdomain.com

# Authentication
LOGIN_VALIDITY=15
OTP_NAME=PKI-Trust-Manager
EMAIL_VERIFICATION=true

# Email/SMTP Configuration
SMTP_SERVER=mail.smtp2go.com
SMTP_PORT=2525
SMTP_AUTH=true
SMTP_SSL=true
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
SMTP_SENDER_NAME="PKI Trust Manager"
SMTP_SENDER=noreply@yourdomain.com

# Certificate Expiry Settings
EXPIRY_START_RANGE=30
EXPIRY_END_RANGE=3
EXPIRY_NOTIFY_INTERVAL=1
EXPIRY_SCAN_INTERVAL=30

# SCEP Configuration
SCEP_OTP_VALIDITY=525600

# Licensing (Contact Securetron for these values)
LICENSE_SERVER_URL=http://localhost:7001
LICENSE_API_KEY=your_license_api_key
CMSWEB_CLIENT_ID=webcore-001
LICENSE_OFFLINE_MODE=true
LICENSE_ONLINE_VALIDATION=false
LICENSE_PUBLIC_KEY=your_public_key_here

# Logging
LOG_LEVEL=Information
LOG_LEVEL_MS=Warning

# Nginx
NGINX_HTTPS_PORT=443
EOF
```

## Configuration

### SSL/TLS Certificate Setup
1. Place your SSL certificates in the `certs/` directory:
```bash
# Certificate files
certs/
├── cert.crt    # SSL Certificate
└── key.pem     # Private Key
```

2. For testing, generate self-signed certificates:
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/key.pem \
  -out certs/cert.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=pki.yourdomain.com"
```

### Nginx Configuration
Create `nginx.conf`:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream pki_web {
        server cmsweb.local:5228;
    }

    server {
        listen 443 ssl http2;
        server_name pki.yourdomain.com;

        ssl_certificate /etc/nginx/cert.crt;
        ssl_certificate_key /etc/nginx/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        location / {
            proxy_pass http://pki_web;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            proxy_buffer_size 128k;
            proxy_buffers 4 256k;
            proxy_busy_buffers_size 256k;
        }

        # Health check endpoint
        location /health {
            proxy_pass http://pki_web/health;
            access_log off;
        }
    }
}
```

## Environment Variables

### Critical Security Variables
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `SQL_SA_PASSWORD` | SQL Server SA password | PKI_Strong@Pass123 | Yes |
| `ADMIN_PASSWORD` | Super admin password | happy | Yes |
| `SMTP_PASSWORD` | SMTP authentication password | - | Yes |
| `LICENSE_API_KEY` | License server API key | - | Yes |
| `LICENSE_PUBLIC_KEY` | Public key for license validation | - | Yes |

### Database Configuration
- Ensure `SQL_SA_PASSWORD` meets complexity requirements
- Change default passwords before production deployment
- Consider using Docker secrets for production
- BYOL for MSSQL when using in Production or use your own MSSQL Server

### Email Configuration
- Configure valid SMTP credentials
- Set proper sender email address
- Test email functionality after deployment

## License Setup

1. **Obtain License Files** from Securetron (https://securetron.net/contact/)
2. **Place license files** in the `license/` directory:
```bash
license/
├── product.lic
└── validation.key
```

3. **Configure licensing parameters** in `.env`:
   - Set `LICENSE_OFFLINE_MODE=true` for air-gapped environments
   - Set `LICENSE_ONLINE_VALIDATION=true` for cloud deployments
   - Contact Securetron for `LICENSE_API_KEY` and `LICENSE_PUBLIC_KEY`

## Deployment Steps

### 1. Initial Deployment
```bash
# Set proper permissions
chmod 600 certs/key.pem
chmod 644 certs/cert.crt

# Pull images
docker-compose pull

# Start services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 2. Verify Deployment
```bash
# Check container status
docker-compose ps

# Check SQL Server health
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa \
  -P "${SQL_SA_PASSWORD}" \
  -Q "SELECT name FROM sys.databases"

# Check web application
curl -k https://localhost/health
```

### 3. Initial Setup
1. Access the web UI: `https://your-server-domain`
2. Login with superadmin credentials from `.env`
3. Complete initial configuration:
   - Configure organizational settings
   - Set up certificate authorities
   - Configure notification templates
   - Add user accounts

## Verification & Testing

### Health Checks
```bash
# Database health
docker-compose exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "${SQL_SA_PASSWORD}" \
  -Q "SELECT 1"

# Application health
curl -f https://localhost/health

# SSL verification
openssl s_client -connect localhost:443 -servername pki.yourdomain.com
```

### Functional Tests
1. **User Authentication**: Login with admin credentials
2. **Certificate Operations**: Issue a test certificate
3. **Email Notifications**: Trigger a test notification
4. **SCEP Protocol**: Test SCEP enrollment (if configured)
5. **Backup/Restore**: Test database backup functionality

## Troubleshooting

### Common Issues

#### 1. SQL Server Connection Issues
```bash
# Check SQL Server logs
docker-compose logs sqlserver

# Verify network connectivity between containers
docker-compose exec cmsweb ping sqlserver.local
```

#### 2. Web Application Not Starting
```bash
# Check application logs
docker-compose logs cmsweb

# Verify environment variables
docker-compose exec cmsweb env | grep ConnectionStrings
```

#### 3. SSL/TLS Issues
```bash
# Verify certificate permissions
ls -la certs/

# Test Nginx configuration
docker-compose exec nginx nginx -t
```

#### 4. License Validation Failures
- Verify license files in `license/` directory
- Check network connectivity to license server
- Validate license expiration dates

### Log Locations
- **Application logs**: Container logs (`docker-compose logs cmsweb`)
- **Database logs**: Container logs (`docker-compose logs sqlserver`)
- **Nginx logs**: Container logs (`docker-compose logs nginx`)
- **Docker logs**: `journalctl -u docker.service`

## Maintenance

### Backup Procedures
```bash
# Database backup
docker-compose exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "${SQL_SA_PASSWORD}" \
  -Q "BACKUP DATABASE [${SQL_DATABASE}] TO DISK='/var/opt/mssql/backup/$(date +%Y%m%d).bak'"

# Configuration backup
tar czf pki-backup-$(date +%Y%m%d).tar.gz \
  docker-compose.yaml .env nginx.conf certs/ license/
```

### Update Procedures
```bash
# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d

# Cleanup old images
docker image prune -f
```

### Monitoring
1. **Resource Monitoring**: CPU, memory, disk usage
2. **Certificate Expiry**: Monitor certificate validity periods
3. **Application Logs**: Regular log review for errors
4. **Database Size**: Monitor database growth

### Security Hardening
1. **Regular Updates**: Keep Docker and images updated
2. **Password Rotation**: Regular password updates
3. **Access Control**: Restrict access to deployment directory
4. **Network Security**: Configure firewall rules appropriately
5. **Audit Logs**: Enable and monitor audit trails
6. **User MFA**: Use built-in TOTP MFA or use Enterprise SSO (SAML / OpenID)

## Support

For technical support:
1. **Documentation**: https://securetron.net/documentation
2. **Support Portal**: https://securetron.net
3. **Emergency Contact**: support@securetron.net

**Note**: This deployment guide is for PKI Trust Manager version 2.x. Always refer to the official documentation for version-specific instructions.
