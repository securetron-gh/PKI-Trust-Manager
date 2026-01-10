# CA-API Proxy Integration with PKI Trust Manager

## 🔗 Integration Guide

This guide explains how to connect your CA-API Proxy Gateway with PKI Trust Manager for seamless certificate management.

---

## 📋 Prerequisites

Before starting integration, ensure:

### CA-API Proxy Requirements:
- ✅ CA-API Proxy installed and running
- ✅ Certificate files in `ca` folder (`cacert.crt`, `cachain.crt`)
- ✅ Service account configured with CA permissions
- ✅ Web application accessible via URL (e.g., `http://ca-server:9081/`)
- ✅ IP restrictions allow PKI Trust Manager server access

### PKI Trust Manager Requirements:
- ✅ PKI Trust Manager installed and running
- ✅ Administrative access to PKI Trust Manager
- ✅ Network connectivity to CA-API Proxy server

---

## 🚀 Step-by-Step Integration

### Step 1: Access PKI Trust Manager

1. **Login** to PKI Trust Manager web interface
2. Navigate to: **Administration Panel** → **Integrations**

### Step 2: Add New Certification Authority

1. Click on **Certification Authorities** section
2. Click the **NEW** button to create a new CA integration

### Step 3: Configure CA Settings

Fill in the **Create CA** form with the following details:

| Field | Value to Enter | Example |
|-------|----------------|---------|
| **Customer** | Select the organization where the CA belongs | `Your Organization Name` |
| **Type** | Select: `Microsoft ADCS Enterprise CA` or `Microsoft Standalone CA` | `Microsoft ADCS Enterprise CA` |
| **Name** | Descriptive name for this CA | `Corporate SSL CA` |
| **API-URL** | Full URL of your CA-API Proxy | `http://ca-server.company.com:9081/` |
| **Status** | Set to: `Active` | `Active` |

#### Detailed Configuration:

**Customer:**
- Select from dropdown list of configured organizations
- This determines which organization can use this CA
- Typically your company/organization name

**Type:**
- **Microsoft ADCS Enterprise CA**: For Active Directory integrated CAs
- **Microsoft Standalone CA**: For standalone/workgroup CAs
- Choose based on your CA type

**Name:**
- Use descriptive name for easy identification
- Example: `Corporate Root CA`, `Internal SSL CA`, `Code Signing CA`
- Will appear in dropdowns throughout the system

**API-URL:**
- Full HTTP URL to your CA-API Proxy
- Format: `http://[server-name]:[port]/`
- Default port: `9081`
- Example: `http://ca-api.company.com:9081/`

**Status:**
- Set to **Active** to enable immediately
- Can be set to **Inactive** for temporary disabling

### Step 4: Test Connection

After saving, PKI Trust Manager will automatically:

1. Test connectivity to the API-URL
2. Verify certificate retrieval from `/cacert` endpoint
3. Validate API responses
4. Display connection status

#### Manual Test Commands:
```powershell
# Test from PKI Trust Manager server
# 1. Test basic connectivity
Test-NetConnection -ComputerName "ca-server" -Port 9081

# 2. Test API endpoint
Invoke-WebRequest -Uri "http://ca-server:9081/" -UseBasicParsing

# 3. Test certificate download
Invoke-WebRequest -Uri "http://ca-server:9081/cacert" -OutFile test.crt

# 4. Test authentication (if required)
$cred = Get-Credential
Invoke-WebRequest -Uri "http://ca-server:9081/templates" -Credential $cred
```

### Step 5: Configure Advanced Settings (Optional)

After creating the CA, click on it to configure additional settings:

#### Templates Mapping
Map PKI Trust Manager certificate templates to Microsoft CA templates:

1. Click **Templates** tab
2. Click **Add Template Mapping**
3. Configure:
   - **PKI Template**: Select from PKI Trust Manager templates
   - **CA Template**: Enter Microsoft CA template name (e.g., `WebServer`)
   - **Validity**: Default certificate validity period
   - **Key Usage**: Key usage constraints

#### Security Settings
1. Click **Security** tab
2. Configure authentication if required:
   - **Authentication Type**: Windows Authentication
   - **Service Account**: Domain\svc-caapi
   - **Credentials**: Store securely in PKI Trust Manager

#### Notification Settings
1. Click **Notifications** tab
2. Configure alerts for:
   - Certificate issuance failures
   - CA connectivity issues
   - Template usage reports

---

## ✅ Verification Steps

### 1. Verify Integration Status
In PKI Trust Manager:
- Go to **Dashboard** → **System Health**
- Check **CA Connections** section
- Should show: ✅ Connected

### 2. Test Certificate Issuance
```powershell
# Using PKI Trust Manager API or Web Interface
# 1. Request a test certificate
# 2. Select the newly added CA
# 3. Choose a certificate template
# 4. Submit request
# 5. Verify certificate is issued successfully
```

### 3. Monitor Integration
Check the following locations for integration status:

#### PKI Trust Manager Logs:
```
# Application logs
- Check PKI Trust Manager (webUI) docker / container logs

# Audit logs
- Check PKI Trust Manager (webUI) docker / container logs
```

#### CA-API Proxy Logs:
```powershell
# Check application logs
Get-Content "C:\Sites\ca-api-proxy\logs\*.log" -Tail 50 | Select-String "PKI"
```

---

## 🔧 Troubleshooting Integration Issues

### Issue 1: "Connection Failed" Error
**Symptoms**: PKI Trust Manager cannot connect to CA-API Proxy

**Solutions**:
```powershell
# 1. Check network connectivity
Test-NetConnection -ComputerName "ca-server" -Port 9081

# 2. Check IIS is running
Get-Service -Name W3SVC

# 3. Check application pool
Get-WebAppPoolState -Name "ca-api-proxy"

# 4. Check firewall rules
Get-NetFirewallRule -DisplayName "*9081*" | Format-Table DisplayName, Enabled
```


### Issue 2: "Certificate Not Found" Error
**Symptoms**: Cannot retrieve CA certificate

**Solutions**:
```powershell
# 1. Verify certificate files exist
Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt"

# 2. Check file permissions
icacls "C:\Sites\ca-api-proxy\ca\cacert.crt"

# 3. Test endpoint manually
curl http://ca-server:9081/cacert
```

### Issue 4: "Template Not Available" Error
**Symptoms**: Certificate templates not showing in PKI Trust Manager

**Solutions**:
```powershell
# 1. Check CA template permissions
certutil -template

# 2. Verify service account has template access
# 3. Check PKI Trust Manager template mappings
```

---

## 🔐 Security Configuration

### 1. Secure Communication
**Recommended**: Use HTTPS for CA-API Proxy
```powershell
# Add SSL certificate to IIS
# 1. Obtain SSL certificate
# 2. Bind HTTPS to port 443
# 3. Update PKI Trust Manager API-URL to https://
```

### 2. IP Restriction Best Practices
```powershell
# Restrict to PKI Trust Manager IP only
Add-WebConfigurationProperty `
    -Filter "/system.webServer/security/ipSecurity" `
    -Name "." `
    -Value @{ipAddress="192.168.1.100";subnetMask="255.255.255.255";allowed="true"}
```

---

## 📊 Monitoring Integration

### PKI Trust Manager Dashboard Metrics
Monitor these metrics after integration:

1. **CA Connection Status**: Should show "ACTIVE"
2. **Certificate Issuance Rate**: Monitor successful/failed requests
3. **Response Time**: API response times from CA-API Proxy
4. **Error Rate**: Failed certificate requests

### Alert Configuration
Set up alerts for:
- CA connectivity loss
- High certificate failure rate
- Slow API response times
- Authentication failures

---

## 🔄 Maintenance Procedures

### Regular Maintenance Tasks

#### Weekly:
1. Check integration logs for errors
2. Verify certificate template availability
3. Test certificate issuance workflow

#### Monthly:
1. Review security permissions
2. Update CA certificate if renewed
3. Backup configuration

#### Quarterly:
1. Review and update template mappings
2. Test disaster recovery procedures
3. Update software components

### Update CA Certificate
When CA certificate is renewed:

1. **Update CA-API Proxy**:
```powershell
# Export new certificate to ca folder
certutil -ca.cert "C:\Sites\ca-api-proxy\ca\cacert.crt"

# Update chain file
# ... generate new cachain.crt ...

# Restart application pool
Restart-WebAppPool -Name "ca-api-proxy"
```

2. **Update PKI Trust Manager**:
   - CA certificate will auto-update via API
   - Verify new certificate appears in PKI Trust Manager


---

## 🎯 Best Practices

### 1. Naming Conventions
- Use consistent naming: `[Location]-[Purpose]-CA`
- Example: `US-East-SSL-CA`, `EU-CodeSign-CA`

### 2. Documentation
- Document CA details: Server, version, templates
- Keep record of service account credentials
- Document certificate renewal dates

### 3. Testing
- Regular integration testing
- Test certificate issuance monthly
- Validate backup/restore procedures

### 4. Security
- Regular permission reviews
- Monitor access logs
- Implement least privilege principle

---

## 📞 Support Resources

### Troubleshooting Checklist
```markdown
- [ ] Network connectivity between servers
- [ ] Firewall ports open (9081 or 443 or 80)
- [ ] IIS running and application pool started
- [ ] Certificate files in ca folder
- [ ] Service account permissions
- [ ] CA configuration string correct
- [ ] PKI Trust Manager CA configuration
- [ ] Template mappings configured
```

### Contact Support
- **PKI Trust Manager Support**: support@securetron.net
- **Documentation**: https://securetron.net/documentation


### Collect Debug Information
```powershell
# Gather troubleshooting data
$debugInfo = @{
    "PKI_Server" = $env:COMPUTERNAME
    "CA_API_URL" = "http://ca-server:9081/"
    "Connection_Test" = Test-NetConnection -ComputerName "ca-server" -Port 9081
    "IIS_Status" = Get-Service -Name W3SVC
    "CA_Cert_Exists" = Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt"
}

$debugInfo | ConvertTo-Json | Out-File "debug-info.json"
```

---

## 🏁 Completion Checklist

After integration, verify:

- [ ] CA appears in PKI Trust Manager CA list
- [ ] Status shows "Active"
- [ ] Test certificate issuance works
- [ ] Certificate templates available
- [ ] Logs show successful connections
- [ ] Monitoring alerts configured

---

**Integration Time**: ~15-30 minutes  
**Testing Time**: ~30 minutes  
**Documentation**: Update internal wiki with CA details

**Next Steps**:
1. Configure certificate templates
2. Set up automated certificate issuance
3. Train users on certificate request process
4. Implement monitoring and alerts
