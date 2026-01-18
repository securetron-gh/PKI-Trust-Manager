# PKI Trust Manager - Simple Azure Deployment

## 🚀 Quick Deployment Guide

Deploy PKI Trust Manager on Azure Container Instances with your existing Azure SQL Database.

### Prerequisites Checklist
- ✅ **Azure Subscription** with contributor access
- ✅ **Azure SQL Database** already provisioned
- ✅ **SQL Connection String** ready (server, database, credentials)
- ✅ **Azure CLI** installed (`az --version` to check)

---

## 📋 Step-by-Step Deployment

### 1. Login to Azure
```bash
az login
```

### 2. Create Resource Group (if needed)
```bash
az group create \
  --name pki-trust-manager-rg \
  --location eastus
```

### 3. Deploy PKI Trust Manager Container
```bash
# Replace placeholders with your actual values
az container create \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --image securetron.azurecr.io/pkimain:latest \
  --cpu 2 \
  --memory 4 \
  --ports 5228 \
  --dns-name-label pki-trust-manager-$(date +%s) \
  --environment-variables \
    ASPNETCORE_ENVIRONMENT=Production \
    ConnectionStrings__OurDBContext="Server=YOUR_SQL_SERVER.database.windows.net;Database=YOUR_DATABASE_NAME;User Id=YOUR_USERNAME;Password=YOUR_PASSWORD;MultipleActiveResultSets=true;TrustServerCertificate=True;" \
    Environment__Mode=Cloud \
    Authentication__DefaultSuperAdminUsername=superadmin \
    Authentication__DefaultSuperAdminPassword="ChangeThisPassword123!" \
    Authentication__DefaultSuperAdminEmail=admin@yourdomain.com \
    Smtp__Server="mail.smtp2go.com" \
    Smtp__Port=2525 \
    Smtp__Auth=true \
    Smtp__EnableSsl=true \
    Smtp__Username="your-smtp-username" \
    Smtp__Password="your-smtp-password" \
    Licensing__OfflineMode=true \
  --restart-policy Always
```

### 4. Get Your Application URL
```bash
az container show \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --query "ipAddress.fqdn" \
  --output tsv
```

---

## 🔧 Minimal Required Configuration

Replace these values in the command above:

### 1. SQL Database Connection
```bash
# Your Azure SQL details:
Server=YOUR_SQL_SERVER.database.windows.net
Database=YOUR_DATABASE_NAME
User Id=YOUR_USERNAME
Password=YOUR_PASSWORD
```

### 2. Admin Credentials
```bash
Authentication__DefaultSuperAdminUsername=superadmin
Authentication__DefaultSuperAdminPassword="YourSecurePasswordHere"
```

### 3. SMTP Configuration (Optional but recommended)
```bash
Smtp__Server="your-smtp-server.com"
Smtp__Username="your-username"
Smtp__Password="your-password"
```

---

## 🎯 One-Line Deployment Script

Save this as `deploy-pki.sh`:

```bash
#!/bin/bash

# Set your variables here
RESOURCE_GROUP="pki-trust-manager-rg"
LOCATION="eastus"
SQL_SERVER="your-sql-server.database.windows.net"
SQL_DATABASE="PKIDBEE"
SQL_USER="your-sql-username"
SQL_PASSWORD="your-sql-password"
ADMIN_PASSWORD="YourAdminPassword123!"

# Run deployment
az container create \
  --resource-group $RESOURCE_GROUP \
  --name pki-trust-manager \
  --image securetron.azurecr.io/pkimain:latest \
  --cpu 2 --memory 4 --ports 5228 \
  --dns-name-label pki-trust-manager-$(date +%s) \
  --environment-variables \
    ConnectionStrings__OurDBContext="Server=$SQL_SERVER;Database=$SQL_DATABASE;User Id=$SQL_USER;Password=$SQL_PASSWORD;MultipleActiveResultSets=true;TrustServerCertificate=True;" \
    Authentication__DefaultSuperAdminUsername=superadmin \
    Authentication__DefaultSuperAdminPassword="$ADMIN_PASSWORD" \
    Authentication__DefaultSuperAdminEmail=admin@yourdomain.com \
    Licensing__OfflineMode=true \
  --restart-policy Always

# Get the URL
echo "Your PKI Trust Manager is deployed at:"
az container show \
  --resource-group $RESOURCE_GROUP \
  --name pki-trust-manager \
  --query "ipAddress.fqdn" \
  --output tsv
```

Make it executable and run:
```bash
chmod +x deploy-pki.sh
./deploy-pki.sh
```

---

## ✅ Verification Steps

### 1. Check Deployment Status
```bash
az container show \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --query "provisioningState"
```

### 2. View Container Logs
```bash
az container logs \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager
```

### 3. Test Application
```bash
# Get the FQDN
URL=$(az container show \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --query "ipAddress.fqdn" \
  --output tsv)

# Test connection
curl http://$URL:5228/health
```

---

## 🐛 Troubleshooting Common Issues

### Issue 1: "Image pull failed"
```bash
# Check if you can pull the image
docker pull securetron.azurecr.io/pkimain:latest
```

### Issue 2: "Cannot connect to database"
```bash
# Test SQL connectivity
az container exec \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --exec-command "ping YOUR_SQL_SERVER.database.windows.net"

# Check SQL firewall allows Azure services
# In Azure Portal: SQL Server → Firewalls and virtual networks → Allow Azure services = ON
```

### Issue 3: Container keeps restarting
```bash
# Check detailed logs
az container logs \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --follow
```

---

## 📊 Post-Deployment Setup

### 1. Access the Application
1. Go to: `http://YOUR_FQDN:5228`
2. Login with:
   - Username: `superadmin`
   - Password: `[Your set password]`

### 2. Initial Configuration
1. Change the default admin password
2. Configure your organization settings
3. Set up certificate authorities
4. Configure email notifications

### 3. Enable HTTPS (Optional but recommended)
```bash
# Create an Application Gateway or use Azure Front Door
# This requires SSL certificates
```

---

## 🗑️ Cleanup

Remove the deployment when no longer needed:
```bash
az container delete \
  --resource-group pki-trust-manager-rg \
  --name pki-trust-manager \
  --yes
```

---

## 📞 Need Help?

### Quick Support
1. **Check logs**: `az container logs -g pki-trust-manager-rg -n pki-trust-manager`
2. **Verify SQL connection**: Test connectivity from Azure Portal
3. **Check container status**: `az container show -g pki-trust-manager-rg -n pki-trust-manager`

### Contact Securetron
- **Email**: support@securetron.net
- **Documentation**: https://securetron.net/documentation
- **Community**: https://reddit.com/r/pki

---

**Time to deploy**: ~5 minutes  
**Cost estimate**: ~$20-100/month (Container + SQL)  
**Maintenance**: Automatic with Azure Container Instances
