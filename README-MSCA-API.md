# CA-API Proxy Gateway for PKI Trust Manager

## 📋 Overview

The CA-API Proxy Gateway is a .NET application that acts as a secure proxy between PKI Trust Manager and Microsoft Certificate Authority (CA). It provides RESTful APIs for certificate management operations with Microsoft Enterprise or Standalone CA.

![Architecture](https://img.shields.io/badge/Architecture-.NET_Web_API-blue)
![Requirements](https://img.shields.io/badge/Requirements-IIS%207%2B%20%7C%20.NET%204.7.2%2B-orange)
![CA Support](https://img.shields.io/badge/CA%20Support-Enterprise%20%26%20Standalone-green)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                PKI Trust Manager                         │
├─────────────────────────────────────────────────────────┤
│               CA-API Proxy Gateway                       │
│            (This Application - REST API)                 │
├─────────────────────────────────────────────────────────┤
│            Microsoft Certificate Authority                │
│      (Enterprise CA or Standalone CA)                    │
└─────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

### I. Software Requirements

#### Windows Server Features
```powershell
# Install required Windows features
Install-WindowsFeature -Name Web-Server,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter
```

#### .NET Framework 4.7.2 or Higher
- Download from: https://dotnet.microsoft.com/download/dotnet-framework
- **Required Components**:
  - HTTP Activation
  - .NET Extensibility
  - ISAPI Extensions
  - ISAPI Filters

### II. Environment Requirements

#### For Microsoft Enterprise CA:
- Deploy on **any Windows Server** that is a member of Active Directory
- Server must have network access to the CA server

#### For Microsoft Standalone CA:
- Deploy **directly on the CA Server**
- No Active Directory membership required

## 📁 Directory Structure

### Default Application Directory
```
C:\Sites\ca-api-proxy\
├── bin\                    # Application binaries
├── ca\                    # CA Certificate files (required!)
│   ├── cacert.crt         # CA Certificate (PEM format) - REQUIRED
│   └── cachain.crt        # Full CA Chain (PEM format) - REQUIRED
├── logs\                  # Application logs
├── web.config             # Configuration file
└── (other web files)
```

### Optional Log Directory (External)
```
C:\Logs\ca-api-proxy\
└── (daily log files)
```

## 🔐 Security Configuration

### Service Account Setup

Create a dedicated service account (e.g., `svc-caapi`):

#### 1. Add to IIS_IUSRS Group
```powershell
# Add service account to IIS_IUSRS
net localgroup IIS_IUSRS svc-caapi /add
```

#### 2. Grant CA Management Privileges
1. Open **Certification Authority** console
2. Right-click CA name → **Properties** → **Security** tab
3. Add service account with permissions:
   - **Read Configuration**
   - **Issue and Manage Certificates**
   - **Manage CA**
   - **Request Certificates**

#### 3. Set Directory Permissions
Assign Full Permission to the service account for the application directory via the GUI or Powershell:
```powershell
# Grant full control to application directory
icacls "C:\Sites\ca-api-proxy" /grant "svc-caapi:(OI)(CI)F"

# Grant full control to ca folder specifically
icacls "C:\Sites\ca-api-proxy\ca" /grant "svc-caapi:(OI)(CI)F"

# Grant full control to log directory (if external)
icacls "C:\Logs\ca-api-proxy" /grant "svc-caapi:(OI)(CI)F"
```

#### 4. Service Account Properties
- Password never expires
- User cannot change password
- Logon as a service (optional)

## 🚀 Deployment Steps

### Step 1: Install IIS and .NET Features
```powershell
# Run PowerShell as Administrator

# Install IIS with required features
Install-WindowsFeature -Name `
    Web-Server, `
    Web-ASP-Net45, `
    Web-ISAPI-Ext, `
    Web-ISAPI-Filter, `
    Web-Asp-Net, `
    Web-Net-Ext, `
    Web-ISAPI-Ext, `
    Web-ISAPI-Filter, `
    Web-Http-Redirect, `
    Web-Filtering, `
    Web-Basic-Auth, `
    Web-Windows-Auth, `
    Web-Digest-Auth

# Install .NET Framework 4.7.2 (if not already installed)
# Download from: https://dotnet.microsoft.com/download/dotnet-framework/net472
```

### Step 2: Create Application Directory
```powershell
# Create application directory structure
New-Item -ItemType Directory -Path "C:\Sites\ca-api-proxy" -Force
New-Item -ItemType Directory -Path "C:\Sites\ca-api-proxy\ca" -Force  # IMPORTANT: This folder is required
New-Item -ItemType Directory -Path "C:\Sites\ca-api-proxy\logs" -Force
```

### Step 3: Deploy Application Files
Copy the following files to `C:\Sites\ca-api-proxy\`:
- All .NET binaries and dependencies
- `web.config` file

### Step 4: Configure IIS Website

#### Using IIS Manager:
1. Open **Internet Information Services (IIS) Manager**
2. Right-click **Sites** → **Add Website**
3. Configure:
   - **Site name**: `ca-api-proxy`
   - **Physical path**: `C:\Sites\ca-api-proxy`
   - **Binding**: 
     - Type: `http`
     - IP address: `All Unassigned` (or specific IP)
     - Port: `9081` (recommended)
     - Host name: (leave blank)
4. Click **OK**

#### Using PowerShell:
```powershell
# Import IIS module
Import-Module WebAdministration

# Create new website
New-Website -Name "ca-api-proxy" `
            -PhysicalPath "C:\Sites\ca-api-proxy" `
            -Port 9081 `
            -Force
```

### Step 5: Configure Application Pool

#### Using IIS Manager:
1. Go to **Application Pools**
2. Find `ca-api-proxy` pool (created automatically)
3. Right-click → **Advanced Settings**
4. Set:
   - **.NET CLR version**: `.NET CLR Version v4.0.30319`
   - **Managed pipeline mode**: `Integrated`
   - **Identity**: `svc-caapi` (your service account)
   - **Load User Profile**: `True`

#### Using PowerShell:
```powershell
# Set application pool identity
Set-ItemProperty "IIS:\AppPools\ca-api-proxy" `
                 -Name processModel.identityType `
                 -Value 3  # SpecificUser

Set-ItemProperty "IIS:\AppPools\ca-api-proxy" `
                 -Name processModel.userName `
                 -Value "DOMAIN\svc-caapi"

Set-ItemProperty "IIS:\AppPools\ca-api-proxy" `
                 -Name processModel.password `
                 -Value "YourPassword123!"

# Set .NET version
Set-ItemProperty "IIS:\AppPools\ca-api-proxy" `
                 -Name managedRuntimeVersion `
                 -Value "v4.0"
```

### Step 6: Security Hardening

#### Restrict Access by IP (Recommended)
```powershell
# Allow only specific IPs (e.g., PKI Trust Manager server)
Add-WebConfigurationProperty `
    -Filter "/system.webServer/security/ipSecurity" `
    -Name "." `
    -Value @{ipAddress="192.168.1.100";subnetMask="255.255.255.255";allowed="true"}

# Deny all others
Set-WebConfigurationProperty `
    -Filter "/system.webServer/security/ipSecurity" `
    -Name "allowUnlisted" `
    -Value "false"
```


## ⚙️ Configuration

### Step 1: Prepare Certificate Files in the `ca` Folder

#### ⚠️ IMPORTANT: Certificate files MUST be placed in `C:\Sites\ca-api-proxy\ca\`

#### 1. Extract CA Certificate (PEM format)
```powershell
# Export CA certificate from Microsoft CA to the ca folder
certutil -ca.cert "C:\Sites\ca-api-proxy\ca\cacert.crt"

# Verify the file was created
Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt"
```

#### 2. Create Certificate Chain File in the `ca` folder
Create `C:\Sites\ca-api-proxy\ca\cachain.crt` with the following format:
```
-----BEGIN CERTIFICATE-----
[CA Certificate - Base64 encoded]
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
[Intermediate CA Certificate - Base64 encoded]
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
[Root CA Certificate - Base64 encoded]
-----END CERTIFICATE-----
```

#### Quick Script to Generate Certificate Files:
```powershell
# Save as generate-cert-files.ps1
$caFolder = "C:\Sites\ca-api-proxy\ca"

# Export CA certificate
certutil -ca.cert "$caFolder\cacert.crt"

# Export full chain (adjust for your CA hierarchy)
# For a two-tier hierarchy:
$caCert = Get-Content "$caFolder\cacert.crt" -Raw
$rootCert = certutil -root | Select-String "-----BEGIN CERTIFICATE-----", "-----END CERTIFICATE-----" | Out-String
$chain = $caCert + "`n`n" + $rootCert
$chain | Out-File -FilePath "$caFolder\cachain.crt" -Encoding ASCII

Write-Host "Certificate files created in: $caFolder"
Write-Host "- cacert.crt (CA certificate)"
Write-Host "- cachain.crt (Full certificate chain)"
```

### Step 2: Get CA Configuration String
```cmd
# Open Command Prompt as Administrator
certutil -getconfig

# Output will look like:
# CA\CA-Computer-Name\CA-Name
# Copy this string for web.config
```

### Step 3: Configure web.config

Edit `C:\Sites\ca-api-proxy\web.config`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.web>
    <compilation debug="false" targetFramework="4.7.2" />
    <httpRuntime targetFramework="4.7.2" />
  </system.web>
  
  <system.webServer>
    <modules runAllManagedModulesForAllRequests="true" />
  </system.webServer>
  
  <appSettings>
    <!-- CA Configuration string from certutil -getconfig -->
    <add key="CAConfig" value="CA\CA-SERVER-NAME\CA-NAME" />
    
    <!-- CA Certificate filename (must be in ca folder) -->
    <add key="cacert-filename" value="cacert.crt" />
    
    <!-- Path for log files -->
    <add key="LogPath" value="C:\Sites\ca-api-proxy\logs" />
    
    <!-- Optional: Enable debug logging -->
    <add key="DebugMode" value="false" />
    
    <!-- Optional: Maximum request size in KB (default: 4096) -->
    <add key="MaxRequestSize" value="8192" />
  </appSettings>
</configuration>
```

### Step 4: Set Permissions for the `ca` Folder
```powershell
# Grant full control to service account on the ca folder
icacls "C:\Sites\ca-api-proxy\ca" /grant "svc-caapi:(OI)(CI)F"

# Also grant read permissions to IIS_IUSRS (if needed)
icacls "C:\Sites\ca-api-proxy\ca" /grant "IIS_IUSRS:(OI)(CI)R"
```

### Step 5: Restart Application
```powershell
# Restart application pool
Restart-WebAppPool -Name "ca-api-proxy"

# Or restart IIS
iisreset
```

## ✅ Testing & Verification

### Test 1: Verify Certificate Files Location
```powershell
# Check if certificate files are in the correct location
Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt"
Test-Path "C:\Sites\ca-api-proxy\ca\cachain.crt"

# Check file permissions
icacls "C:\Sites\ca-api-proxy\ca\cacert.crt"
icacls "C:\Sites\ca-api-proxy\ca\cachain.crt"
```

### Test 2: API Information Endpoint
```powershell
# Test using PowerShell
$response = Invoke-WebRequest -Uri "http://localhost:9081/" -UseBasicParsing
Write-Host "Status Code:" $response.StatusCode
Write-Host "Response:" $response.Content
```

Expected output should show API version and available endpoints.

### Test 3: Download CA Certificate (from ca folder)
```powershell
# This endpoint reads from C:\Sites\ca-api-proxy\ca\cacert.crt
Invoke-WebRequest -Uri "http://localhost:9081/cacert" `
                  -OutFile "C:\temp\ca-certificate.crt"

# Verify the file matches what's in the ca folder
$apiCert = Get-Content "C:\temp\ca-certificate.crt" -Raw
$caFolderCert = Get-Content "C:\Sites\ca-api-proxy\ca\cacert.crt" -Raw
$apiCert -eq $caFolderCert
```

### Test 4: Download Full CA Chain (from ca folder)
```powershell
# This endpoint reads from C:\Sites\ca-api-proxy\ca\cachain.crt
Invoke-WebRequest -Uri "http://localhost:9081/cachain" `
                  -OutFile "C:\temp\ca-chain.pem"

# Count certificates in chain
$chain = Get-Content "C:\temp\ca-chain.pem"
($chain | Select-String "BEGIN CERTIFICATE").Count
```

### Test 5: Check Application Logs
```powershell
# Check if logs are being created
Get-ChildItem "C:\Sites\ca-api-proxy\logs" -Filter "*.log" | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 1

# View the latest log
$latestLog = Get-ChildItem "C:\Sites\ca-api-proxy\logs" -Filter "*.log" | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
Get-Content $latestLog.FullName -Tail 20
```

## 🔌 Integration with PKI Trust Manager

### Configure PKI Trust Manager
In PKI Trust Manager settings:

1. **CA Type**: Select "Microsoft CA via Proxy"
2. **Proxy URL**: `http://ca-api-server:9081/`
3. **Authentication**: Windows Authentication (using service account)
4. **CA Config**: Same as in web.config

### Test Integration from PKI Trust Manager
```powershell
# Example test from PKI Trust Manager server
$cred = Get-Credential
$response = Invoke-RestMethod -Uri "http://ca-api-server:9081/templates" `
                              -Method Get `
                              -Credential $cred

Write-Host "Available certificate templates:"
$response | Format-Table
```

## 🐛 Troubleshooting

### Common Issues & Solutions

#### Issue 1: "CA Certificate file not found"
**Error**: Application cannot find `cacert.crt` in the `ca` folder
```powershell
# Fix: Verify file location and permissions
Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt"

# Fix: Check web.config - cacert-filename should be "cacert.crt"
Get-Content "C:\Sites\ca-api-proxy\web.config" | Select-String "cacert-filename"
```

#### Issue 2: "Access denied to ca folder"
**Error**: Service account cannot read certificate files
```powershell
# Fix: Grant explicit permissions
icacls "C:\Sites\ca-api-proxy\ca" /grant "svc-caapi:(OI)(CI)F"
icacls "C:\Sites\ca-api-proxy\ca\cacert.crt" /grant "svc-caapi:F"
icacls "C:\Sites\ca-api-proxy\ca\cachain.crt" /grant "svc-caapi:F"
```

#### Issue 3: Incorrect CA Configuration String
**Error**: Cannot connect to Microsoft CA
```powershell
# Fix: Get correct CA configuration string
certutil -getconfig

# Update web.config with the correct value
# Format: CA\Server-Name\CA-Name
```

#### Issue 4: Certificate files in wrong format
**Error**: Cannot parse certificate files
```powershell
# Fix: Ensure files are in PEM format
# Check first line of cacert.crt
Get-Content "C:\Sites\ca-api-proxy\ca\cacert.crt" -First 1
# Should show: -----BEGIN CERTIFICATE-----
```

### Diagnostic Commands
```powershell
# Check all prerequisites
Write-Host "=== CA-API Proxy Diagnostic Check ==="

# 1. Check ca folder exists
Write-Host "1. CA Folder: " -NoNewline
if (Test-Path "C:\Sites\ca-api-proxy\ca") {
    Write-Host "✓ Exists" -ForegroundColor Green
} else {
    Write-Host "✗ Missing!" -ForegroundColor Red
}

# 2. Check certificate files
Write-Host "2. cacert.crt: " -NoNewline
if (Test-Path "C:\Sites\ca-api-proxy\ca\cacert.crt") {
    Write-Host "✓ Exists" -ForegroundColor Green
} else {
    Write-Host "✗ Missing!" -ForegroundColor Red
}

Write-Host "3. cachain.crt: " -NoNewline
if (Test-Path "C:\Sites\ca-api-proxy\ca\cachain.crt") {
    Write-Host "✓ Exists" -ForegroundColor Green
} else {
    Write-Host "✗ Missing!" -ForegroundColor Red
}

# 3. Check web.config
Write-Host "4. web.config: " -NoNewline
if (Test-Path "C:\Sites\ca-api-proxy\web.config") {
    Write-Host "✓ Exists" -ForegroundColor Green
} else {
    Write-Host "✗ Missing!" -ForegroundColor Red
}

# 4. Check IIS site
Write-Host "5. IIS Site: " -NoNewline
if (Get-Website -Name "ca-api-proxy" -ErrorAction SilentlyContinue) {
    Write-Host "✓ Running" -ForegroundColor Green
} else {
    Write-Host "✗ Not found!" -ForegroundColor Red
}
```

## 🔒 Security Best Practices

### 1. Certificate File Security
- Keep certificate files in the `ca` folder only
- Regular permissions audit on the `ca` folder
- Monitor for unauthorized access attempts
- Backup certificate files securely

### 2. Network Security
- Deploy in internal network only
- Use IP restrictions to allow only PKI Trust Manager
- Consider using HTTPS (requires SSL certificate on IIS)

### 3. Service Account Security
- Use dedicated service account
- Regular password rotation
- Monitor account usage in security logs
- Least privilege principle

### 4. File System Security
```powershell
# Set restrictive permissions on ca folder
icacls "C:\Sites\ca-api-proxy\ca" /inheritance:r
icacls "C:\Sites\ca-api-proxy\ca" /grant "svc-caapi:(OI)(CI)R"
icacls "C:\Sites\ca-api-proxy\ca" /grant "Administrators:(OI)(CI)F"
```

## 📊 API Endpoints

| Endpoint | Method | Description | Authentication |
|----------|--------|-------------|----------------|
| `/` | GET | API information and health check | None |
| `/cacert` | GET | Download CA certificate from `ca\cacert.crt` | Windows Auth |
| `/cachain` | GET | Download full CA chain from `ca\cachain.crt` | Windows Auth |
| `/templates` | GET | List available certificate templates | Windows Auth |
| `/issue` | POST | Issue new certificate | Windows Auth |
| `/renew` | POST | Renew existing certificate | Windows Auth |
| `/revoke` | POST | Revoke certificate | Windows Auth |
| `/status/{requestId}` | GET | Check certificate status | Windows Auth |
| `/download/{certId}` | GET | Download issued certificate | Windows Auth |

## 🔄 Maintenance

### Regular Tasks
1. **Certificate Updates**: Update `ca\cacert.crt` and `ca\cachain.crt` when CA certificate is renewed
2. **Log Rotation**: Configure IIS and application log rotation
3. **Security Updates**: Apply Windows and .NET security patches
4. **Permission Audits**: Regular review of folder permissions

### Update CA Certificate Files
```powershell
# Script to update certificate files
$caFolder = "C:\Sites\ca-api-proxy\ca"

# Stop application pool
Stop-WebAppPool -Name "ca-api-proxy"

# Backup old certificates
Copy-Item "$caFolder\cacert.crt" "$caFolder\cacert.crt.backup_$(Get-Date -Format 'yyyyMMdd')"
Copy-Item "$caFolder\cachain.crt" "$caFolder\cachain.crt.backup_$(Get-Date -Format 'yyyyMMdd')"

# Export new CA certificate
certutil -ca.cert "$caFolder\cacert.crt"

# Update chain file (adjust as needed)
# ... generate new cachain.crt ...

# Start application pool
Start-WebAppPool -Name "ca-api-proxy"
```

### Backup Script
```powershell
# backup-ca-api.ps1
$backupDir = "D:\Backups\ca-api-proxy\$(Get-Date -Format 'yyyyMMdd')"
New-Item -ItemType Directory -Path $backupDir -Force

# Backup critical files
Copy-Item "C:\Sites\ca-api-proxy\web.config" -Destination "$backupDir\"
Copy-Item "C:\Sites\ca-api-proxy\ca\" -Destination "$backupDir\ca\" -Recurse
Copy-Item "C:\Sites\ca-api-proxy\logs\" -Destination "$backupDir\logs\" -Recurse
```

## 📞 Support

### Log Collection for Support
```powershell
# Collect troubleshooting data
$zipFile = "C:\Temp\ca-api-troubleshoot-$(Get-Date -Format 'yyyyMMdd-HHmm').zip"

# Include ca folder contents
Compress-Archive `
    -Path "C:\Sites\ca-api-proxy\ca\*", `
          "C:\Sites\ca-api-proxy\logs\*", `
          "C:\Sites\ca-api-proxy\web.config" `
    -DestinationPath $zipFile

Write-Host "Troubleshooting package created: $zipFile"
```

### Contact Information
- **Support Email**: support@securetron.com
- **Documentation**: https://docs.securetron.com/ca-api-proxy
- **Emergency Support**: +1-XXX-XXX-XXXX

---

## 📝 Quick Reference Commands

```powershell
# Essential commands
# 1. Restart application
Restart-WebAppPool -Name "ca-api-proxy"

# 2. Check certificate files
dir C:\Sites\ca-api-proxy\ca\

# 3. Test endpoints
curl http://localhost:9081/cacert

# 4. View logs
Get-ChildItem C:\Sites\ca-api-proxy\logs\*.log | Sort LastWriteTime | Select -Last 1 | Get-Content -Tail 50

# 5. Verify CA connection
certutil -ping -config "CA\SERVER-NAME\CA-NAME"
```

---

**Key Points**:
1. **Certificate files MUST be in `C:\Sites\ca-api-proxy\ca\` folder**
2. **Two required files**: `cacert.crt` and `cachain.crt`
3. **Service account must have read permissions to the ca folder**
4. **CA configuration string must be correct in web.config**

**Deployment Time**: ~30 minutes  
**Security**: Windows Authentication + IP Restrictions  
**Compatibility**: Microsoft CA (Enterprise/Standalone)  
**Integration**: REST API for PKI Trust Manager
