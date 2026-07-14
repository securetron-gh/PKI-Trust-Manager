<#
.SYNOPSIS
    Installs the PKI Trust Manager Windows CA API Proxy (WinCaApiEE) on IIS.

.DESCRIPTION
    This script automates the full deployment of WinCaApiEE v2.1.1 on Windows Server.
    It performs the following steps:
      1. Prompts for user identity (current / new domain user / existing user).
      2. Installs IIS + Management Tools + WCF HTTP Activation if missing.
      3. Copies application files to the target directory.
      4. Creates an IIS Application Pool with the chosen identity.
      5. Creates an IIS Website with HTTP (80) binding.
      6. Attempts TLS certificate enrolment via ADCS (Server Authentication template).
         Falls back to a self-signed certificate when no template is available.
      7. Binds the certificate on HTTPS (443).
      8. Grants the service account Full Control on the application folder.
      9. Prompts for and applies CA configuration settings in web.config.

.NOTES
    Requires: Windows Server 2016+, .NET Framework 4.7.2+,
              PowerShell elevated (Run as Administrator).
    Version:  2.0
#>

#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$SourcePath,
    [string]$DestinationPath = "C:\inetpub\caproxyapi",
    [string]$SiteDomain,
    [switch]$SkipIISInstall
)

# Configuration defaults
$appPoolName   = "caapi"
$siteName      = "caapi"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  PKI Trust Manager - WinCaApiEE Installer" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Helper function
function Write-Step {
    param([string]$Text)
    Write-Host "`n>> $Text" -ForegroundColor Yellow
}

# Locate source directory
if (-not $SourcePath) {
    $probePaths = @(
        ".\WinCaApiEE-v2.1.1",
        ".\bin",
        (Join-Path $PSScriptRoot "WinCaApiEE-v2.1.1"),
        (Join-Path $PSScriptRoot "bin")
    )
    foreach ($p in $probePaths) {
        if (Test-Path (Join-Path $p "Web.config")) {
            $SourcePath = $p
            break
        }
    }
    if (-not $SourcePath) {
        $SourcePath = Read-Host "Enter the path to the WinCaApiEE application files (folder containing Web.config)"
        if (-not (Test-Path (Join-Path $SourcePath "Web.config"))) {
            Write-Error "No Web.config found under '$SourcePath'. Aborting."
            exit 1
        }
    }
}
Write-Host "[i] Source path: $SourcePath" -ForegroundColor Gray

if (-not $SiteDomain) {
    $defaultDomain = "$env:COMPUTERNAME.$env:USERDNSDOMAIN"
    if (-not $env:USERDNSDOMAIN) { $defaultDomain = "$env:COMPUTERNAME.local" }
    $SiteDomain = Read-Host "Enter the DNS name for the CA Proxy website (default: $defaultDomain)"
    if (-not $SiteDomain) { $SiteDomain = $defaultDomain }
}
Write-Host "[i] Site DNS name: $SiteDomain" -ForegroundColor Gray

# ============================================================
# 1 - User identity selection
# ============================================================
Write-Step "Step 1 - Application Pool Identity"

Write-Host "Choose the identity for the IIS Application Pool:"
Write-Host "  1) Use current user ($env:USERDOMAIN\$env:USERNAME)"
Write-Host "  2) Create a new domain user"
Write-Host "  3) Specify an existing domain user"
$choice = Read-Host "Enter choice (1/2/3)"
Write-Host ""

switch ($choice) {
    "1" {
        $appPoolUser = "$env:USERDOMAIN\$env:USERNAME"
        $appPoolPassword = $null
        Write-Host "[i] Using current user: $appPoolUser" -ForegroundColor Green
    }
    "2" {
        $newUser = Read-Host "Enter the SamAccountName for the new user (e.g. svc_caapi)"
        if (-not $newUser) { $newUser = "svc_caapi" }

        Add-Type -AssemblyName System.Web
        $newPassword = [System.Web.Security.Membership]::GeneratePassword(18, 4)
        Write-Host "[i] Generated password: $newPassword" -ForegroundColor Gray

        $securePwd = ConvertTo-SecureString $newPassword -AsPlainText -Force

        # Try AD PowerShell first, fall back to ADSI
        try {
            if (Get-Module -ListAvailable -Name ActiveDirectory) {
                Import-Module ActiveDirectory -ErrorAction Stop
                $existing = Get-ADUser -Identity $newUser -ErrorAction SilentlyContinue
                if (-not $existing) {
                    New-ADUser -Name $newUser -SamAccountName $newUser `
                        -AccountPassword $securePwd -Enabled $true `
                        -PasswordNeverExpires $true -ErrorAction Stop
                    Write-Host "[+] Domain user '$newUser' created (AD PowerShell)." -ForegroundColor Green
                } else {
                    Write-Host "[i] User '$newUser' already exists. Updating password to match..." -ForegroundColor Yellow
                    Set-ADAccountPassword -Identity $newUser -Reset -NewPassword $securePwd
                    Write-Host "[+] Password synchronized for existing user." -ForegroundColor Green
                }
            } else {
                # ADSI fallback
                $dcRoot = [ADSI]"LDAP://$env:USERDNSDOMAIN/CN=Users,$(([ADSI]"LDAP://$env:USERDNSDOMAIN/rootDSE").defaultNamingContext)"
                $searcher = New-Object DirectoryServices.DirectorySearcher([ADSI]"LDAP://$env:USERDNSDOMAIN")
                $searcher.Filter = "(sAMAccountName=$newUser)"
                $existing = $searcher.FindOne()

                if (-not $existing) {
                    $userObj = $dcRoot.Create("user", "CN=$newUser")
                    $userObj.Put("sAMAccountName", $newUser)
                    $userObj.Put("userPrincipalName", "$newUser@$env:USERDNSDOMAIN")
                    $userObj.Put("displayName", "WinCaApiEE Service Account")
                    $userObj.SetInfo()
                    $userObj.Invoke("SetPassword", $newPassword)
                    $userObj.Put("userAccountControl", 512)
                    $userObj.SetInfo()
                    Write-Host "[+] Domain user '$newUser' created (ADSI)." -ForegroundColor Green
                } else {
                    Write-Host "[i] User '$newUser' already exists. Updating password to match..." -ForegroundColor Yellow
                    $userObj = [ADSI]"LDAP://$env:USERDNSDOMAIN/CN=$newUser,CN=Users,$(([ADSI]"LDAP://$env:USERDNSDOMAIN/rootDSE").defaultNamingContext)"
                    $userObj.Invoke("SetPassword", $newPassword)
                    Write-Host "[+] Password synchronized for existing user." -ForegroundColor Green
                }
            }
            $appPoolUser = "$env:USERDOMAIN\$newUser"
            $appPoolPassword = $newPassword
        }
        catch {
            Write-Error "Failed to create domain user: $_"
            Write-Warning "Falling back to ApplicationPoolIdentity."
            $appPoolUser = $null
            $appPoolPassword = $null
        }
    }
    "3" {
        $existingUser = Read-Host "Enter the domain\username (e.g. DOMAIN\svc_caapi)"
        $appPoolUser = $existingUser
        $securePwd = Read-Host "Enter the password for $existingUser" -AsSecureString
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
        $appPoolPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        
        $userOnly = ($existingUser -split '\\')[-1]
        Write-Host "Synchronizing AD password for $userOnly..." -ForegroundColor Yellow
        try {
            $syncPwd = ConvertTo-SecureString $appPoolPassword -AsPlainText -Force
            if (Get-Module -ListAvailable -Name ActiveDirectory) {
                Import-Module ActiveDirectory -ErrorAction Stop
                Set-ADAccountPassword -Identity $userOnly -Reset -NewPassword $syncPwd -ErrorAction SilentlyContinue
            } else {
                $dcRoot = [ADSI]"LDAP://$env:USERDNSDOMAIN/CN=$userOnly,CN=Users,$(([ADSI]"LDAP://$env:USERDNSDOMAIN/rootDSE").defaultNamingContext)"
                $dcRoot.Invoke("SetPassword", $appPoolPassword)
            }
            Write-Host "[+] Password synchronized for $existingUser." -ForegroundColor Green
        } catch {
            Write-Host "[i] Password sync skipped: $($_.Exception.Message)" -ForegroundColor Yellow
        }
        
        Write-Host "[i] Using existing user: $appPoolUser" -ForegroundColor Green
    }
    default {
        Write-Error "Invalid selection. Aborting."
        exit 1
    }
}

# ============================================================
# 2 - Install IIS + prerequisites
# ============================================================
Write-Step "Step 2 - IIS Installation"

if (-not $SkipIISInstall) {
    $iisFeatures = @(
        "Web-Server", "Web-WebServer", "Web-Common-Http", "Web-Default-Doc",
        "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content",
        "Web-Http-Logging", "Web-Http-Redirect",
        "Web-Performance", "Web-Stat-Compression",
        "Web-Security", "Web-Filtering", "Web-Windows-Auth",
        "Web-App-Dev", "Web-Net-Ext45", "Web-Asp-Net45",
        "Web-ISAPI-Ext", "Web-ISAPI-Filter",
        "Web-Mgmt-Tools", "Web-Mgmt-Console", "Web-Scripting-Tools",
        "Web-WHC"
    )

    $alreadyInstalled = (Get-WindowsFeature -Name $iisFeatures | Where-Object InstallState -eq 'Installed').Count
    $total = $iisFeatures.Count

    if ($alreadyInstalled -lt $total) {
        Write-Host "Installing IIS and management tools ($alreadyInstalled/$total already installed)..."
        try {
            $result = Install-WindowsFeature -Name $iisFeatures -IncludeManagementTools -Restart:$false
            if ($result.Success -or $result.RestartNeeded) {
                Write-Host "[+] IIS installation completed." -ForegroundColor Green
                if ($result.RestartNeeded) {
                    Write-Warning "A restart is pending. Please reboot before continuing."
                }
            }
        }
        catch {
            Write-Error "IIS installation failed: $_"
            exit 1
        }
    } else {
        Write-Host "[i] IIS already fully installed." -ForegroundColor Green
    }

    Import-Module WebAdministration -Force -ErrorAction Stop
    Write-Host "[i] WebAdministration module loaded." -ForegroundColor Gray
} else {
    Write-Host "[i] Skipping IIS installation (-SkipIISInstall)." -ForegroundColor Yellow
}

# ============================================================
# 3 - Copy application files
# ============================================================
Write-Step "Step 3 - Deploying Application Files"

if (-not (Test-Path $DestinationPath)) {
    New-Item -Path $DestinationPath -ItemType Directory -Force | Out-Null
    Write-Host "[+] Created directory: $DestinationPath" -ForegroundColor Green
}

Write-Host "Copying files from '$SourcePath' to '$DestinationPath'..."
Copy-Item -Path "$SourcePath\*" -Destination $DestinationPath -Recurse -Force

$criticalFiles = @("Web.config", "Global.asax", "bin\WinCaApiEE.dll")
foreach ($f in $criticalFiles) {
    $fp = Join-Path $DestinationPath $f
    if (Test-Path $fp) {
        Write-Host "  [OK] $f" -ForegroundColor Green
    } else {
        Write-Warning "  [MISSING] $f - deployment may be incomplete."
    }
}

# ============================================================
# 4 - IIS Application Pool
# ============================================================
Write-Step "Step 4 - Application Pool"

$appCmd = "$env:SystemRoot\system32\inetsrv\appcmd.exe"

if (Test-Path "IIS:\AppPools\$appPoolName") {
    Remove-WebAppPool -Name $appPoolName -ErrorAction SilentlyContinue
    Write-Host "[i] Removed existing app pool '$appPoolName'."
}

& $appCmd add apppool /name:$appPoolName /managedRuntimeVersion:v4.0 2>&1 | Out-Null

if ($appPoolUser -and $appPoolPassword) {
    Write-Host "Setting identity to: $appPoolUser"
    & $appCmd set apppool $appPoolName /processModel.identityType:SpecificUser 2>&1 | Out-Null
    & $appCmd set apppool $appPoolName /processModel.userName:"$appPoolUser" 2>&1 | Out-Null
    & $appCmd set apppool $appPoolName /processModel.password:"$appPoolPassword" 2>&1 | Out-Null
    Write-Host "[+] App pool '$appPoolName' configured with user '$appPoolUser'." -ForegroundColor Green

    # Add domain user to local IIS_IUSRS group
    try {
        $userNamePart = Split-Path $appPoolUser -Leaf
        $member = Get-LocalGroupMember -Group "IIS_IUSRS" -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -like "*$userNamePart" }
        if (-not $member) {
            Add-LocalGroupMember -Group "IIS_IUSRS" -Member $appPoolUser -ErrorAction SilentlyContinue
            & net localgroup IIS_IUSRS $appPoolUser /add 2>&1 | Out-Null
            Write-Host "[+] Added '$appPoolUser' to IIS_IUSRS." -ForegroundColor Green
        }
    } catch {
        Write-Warning "Could not add user to IIS_IUSRS: $_"
    }
} else {
    Write-Host "[i] Using ApplicationPoolIdentity." -ForegroundColor Yellow
}

# ============================================================
# 5 - IIS Website
# ============================================================
Write-Step "Step 5 - Website"

if (Test-Path "IIS:\Sites\$siteName") {
    Remove-WebSite -Name $siteName -ErrorAction SilentlyContinue
    Start-Sleep 2
    Write-Host "[i] Removed existing site '$siteName'."
}

New-WebSite -Name $siteName `
    -Port 80 `
    -HostHeader $SiteDomain `
    -PhysicalPath $DestinationPath `
    -ApplicationPool $appPoolName `
    -Force | Out-Null

Start-WebSite -Name $siteName
Write-Host "[+] Website '$siteName' created (HTTP *:80:$SiteDomain)." -ForegroundColor Green

# ============================================================
# 5b - NTFS permissions (service account on application folder)
# ============================================================
if ($appPoolUser) {
    Write-Step "Step 5b - NTFS Permissions"
    try {
        $acl = Get-Acl -Path $DestinationPath
        $perm = @($appPoolUser, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $perm
        $acl.SetAccessRule($accessRule)
        Set-Acl -Path $DestinationPath -AclObject $acl
        Write-Host "[+] FullControl granted to '$appPoolUser' on '$DestinationPath'." -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not set NTFS permissions: $_"
    }
}

# ============================================================
# 6 - TLS / SSL certificate
# ============================================================
Write-Step "Step 6 - TLS / SSL Certificate"

$cert = $null

# Auto-discover ADCS templates that support Server Authentication
Write-Host "Scanning for ADCS enrollment templates with Server Authentication EKU..."
try {
    if (Get-Module -ListAvailable -Name PKI) {
        Import-Module PKI -Force -ErrorAction Stop
    }

    $caTemplates = certutil -CATemplates 2>&1 | Out-String
    Write-Host "  Templates found via certutil." -ForegroundColor Gray

    $knownTlsTemplates = @("WebServer", "Web Server", "IIS", "SSL", "TLS")
    $chosenTemplate = $null
    foreach ($tpl in $knownTlsTemplates) {
        $check = certutil -CATemplates 2>&1 | Select-String -Pattern $tpl -SimpleMatch
        if ($check) {
            $chosenTemplate = $tpl
            Write-Host "  [+] Found template matching '$tpl'." -ForegroundColor Green
            break
        }
    }

    if ($chosenTemplate) {
        Write-Host "Attempting certificate enrollment using template '$chosenTemplate'..."
        $certReq = Get-Certificate -Template $chosenTemplate `
            -DnsName $SiteDomain `
            -CertStoreLocation "Cert:\LocalMachine\My" `
            -ErrorAction Stop
        $cert = $certReq.Certificate
        Write-Host "[+] Certificate enrolled from ADCS (template: $chosenTemplate)." -ForegroundColor Green
    }
    else {
        Write-Host "  No suitable TLS template found among available templates." -ForegroundColor Yellow
    }
}
catch {
    Write-Warning "ADCS certificate enrolment failed: $($_.Exception.Message)"
}

# Fallback: self-signed certificate
if (-not $cert) {
    Write-Host "Generating self-signed certificate for '$SiteDomain'..." -ForegroundColor Yellow
    try {
        $cert = New-SelfSignedCertificate -DnsName $SiteDomain `
            -CertStoreLocation "Cert:\LocalMachine\My" `
            -FriendlyName $SiteDomain `
            -NotAfter (Get-Date).AddYears(5) `
            -KeyUsage DigitalSignature, KeyEncipherment `
            -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1")
        Write-Host "[+] Self-signed certificate created." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create self-signed certificate: $_"
    }
}

if ($cert) {
    Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
    Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
    Write-Host "  Expires: $($cert.NotAfter)" -ForegroundColor Gray

    Get-WebBinding -Name $siteName -Protocol https -ErrorAction SilentlyContinue | Remove-WebBinding -ErrorAction SilentlyContinue

    New-WebBinding -Name $siteName -Protocol https -Port 443 -HostHeader $SiteDomain -IPAddress "*" -SslFlags 1

    $binding = Get-WebBinding -Name $siteName -Protocol https -Port 443 -HostHeader $SiteDomain
    $binding.AddSslCertificate($cert.Thumbprint, "MY")
    Write-Host "[+] HTTPS bound on *:443:$SiteDomain" -ForegroundColor Green
}
else {
    Write-Warning "No certificate was created - HTTPS will not be available."
}

# ============================================================
# 7 - CA Chain Discovery + Web.config
# ============================================================
Write-Step "Step 7 - CA Certificate Chain & Web.config"

$webConfigPath = Join-Path $DestinationPath "Web.config"
$caStore = Join-Path $DestinationPath "ca"
$guid = [Guid]::NewGuid().ToString()

# Create CAStore directory
if (-not (Test-Path $caStore)) {
    New-Item -Path $caStore -ItemType Directory -Force | Out-Null
}

# ------------------------------------------------------------------
# Discover CA cert chain from all available sources
# ------------------------------------------------------------------
$chainCerts = @{}  # thumbprint -> cert (deduplication)

# === SOURCE 1: COM ICertRequest2::GetCACertificate (most direct) ===
Write-Host "Source 1: Querying CA via ICertRequest2..." -ForegroundColor Yellow
$caConfig = $null
try {
    $certreq = New-Object -ComObject CertificateAuthority.Request
    $pingResult = certutil -config '' -ping 2>&1 | Select-String 'Config:'
    if ($pingResult) {
        $caConfig = ($pingResult -split 'Config:\s+')[-1].Trim()
    } else {
        $dump = certutil -dump 2>&1
        if ($dump -match 'Config:\s+([^\r\n]+)') { $caConfig = $matches[1].Trim() }
    }
    if ($caConfig) {
        $pemData = $certreq.GetCACertificate(0x1, $caConfig, 0)
        if ($pemData) {
            $pemPattern = '(?s)-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----'
            $pemMatches = [regex]::Matches($pemData, $pemPattern)
            Write-Host "  Found $($pemMatches.Count) cert(s) from CA server"
            foreach ($m in $pemMatches) {
                $b64 = $m.Value -replace '-----BEGIN CERTIFICATE-----', '' -replace '-----END CERTIFICATE-----', '' -replace '\s',''
                $der = [System.Convert]::FromBase64String($b64)
                $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @(,$der)
                if (-not $chainCerts.ContainsKey($cert.Thumbprint)) {
                    $chainCerts[$cert.Thumbprint] = $cert
                    Write-Host "    $($cert.Subject)" -ForegroundColor Green
                }
            }
        }
    }
} catch {
    Write-Host "  COM failed, falling back: $($_.Exception.Message)" -ForegroundColor DarkGray
}

# === SOURCE 2: Local certificate stores ===
Write-Host "Source 2: Scanning local certificate stores..." -ForegroundColor Yellow
$storePaths = @('Cert:\LocalMachine\CA', 'Cert:\LocalMachine\Root')
foreach ($storePath in $storePaths) {
    if (Test-Path $storePath) {
        Get-ChildItem $storePath -ErrorAction SilentlyContinue | ForEach-Object {
            $cert = $_
            $isCA = ($cert.Subject -match 'CA' -or $cert.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.19' })
            if ($isCA -and -not $chainCerts.ContainsKey($cert.Thumbprint)) {
                $chainCerts[$cert.Thumbprint] = $cert
                Write-Host "    $($cert.Subject) [from store]" -ForegroundColor Green
            }
        }
    }
}

# === SOURCE 3: Follow issuer chain upward ===
Write-Host "Source 3: Following issuer chain..." -ForegroundColor Yellow
$queue = @($chainCerts.Values | ForEach-Object { $_ })
$visited = @{}
while ($queue.Count -gt 0) {
    $current = $queue[0]; $queue = $queue[1..($queue.Count-1)]
    if ($visited.ContainsKey($current.Thumbprint)) { continue }
    $visited[$current.Thumbprint] = $true
    if ($current.Subject -ne $current.Issuer) {
        foreach ($storePath in $storePaths) {
            if (Test-Path $storePath) {
                Get-ChildItem $storePath -ErrorAction SilentlyContinue | Where-Object { $_.Subject -eq $current.Issuer } | ForEach-Object {
                    if (-not $chainCerts.ContainsKey($_.Thumbprint)) {
                        $chainCerts[$_.Thumbprint] = $_
                        Write-Host "    Issuer: $($_.Subject)" -ForegroundColor Green
                        $queue += $_
                    }
                }
            }
        }
    }
}

# === SOURCE 4: AIA (Authority Information Access) URLs ===
Write-Host "Source 4: Checking AIA URLs..." -ForegroundColor Yellow
$missing = $chainCerts.Values | Where-Object { $_.Subject -ne $_.Issuer -and -not ($chainCerts.Values | Where-Object { $_.Subject -eq $_.Issuer }) }
if ($missing) {
    foreach ($cert in $chainCerts.Values) {
        $aiaExt = $cert.Extensions | Where-Object { $_.Oid.Value -eq '1.3.6.1.5.5.7.1.1' }
        if ($aiaExt) {
            $raw = $aiaExt.Format($true) -split "`r`n"
            $urls = $raw | Select-String 'http' | ForEach-Object { ($_ -split 'URL=')[-1].Trim() }
            foreach ($url in $urls) {
                Write-Host "  AIA: $url" -ForegroundColor DarkGray
                try {
                    $wc = New-Object System.Net.WebClient
                    $wc.Timeout = 15000
                    $aiaDer = $wc.DownloadData($url)
                    $aiaCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @(,$aiaDer)
                    if (-not $chainCerts.ContainsKey($aiaCert.Thumbprint)) {
                        $chainCerts[$aiaCert.Thumbprint] = $aiaCert
                        Write-Host "    $($aiaCert.Subject) [from AIA]" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "    AIA failed: $($_.Exception.Message)" -ForegroundColor DarkGray
                }
            }
        }
    }
}

# === SOURCE 5: AD pKIEnrollmentService ===
Write-Host "Source 5: Checking Active Directory..." -ForegroundColor Yellow
try {
    $rootDSE = [ADSI]'LDAP://RootDSE'
    $configNC = $rootDSE.configurationNamingContext
    if ($configNC) {
        $searcher = New-Object DirectoryServices.DirectorySearcher
        $searcher.SearchRoot = New-Object DirectoryServices.DirectoryEntry("LDAP://$configNC")
        $searcher.Filter = '(objectClass=pKIEnrollmentService)'
        $searcher.PageSize = 100
        $searcher.SearchScope = 'Subtree'
        $results = $searcher.FindAll()
        foreach ($r in $results) {
            $caCertBytes = $r.Properties['caCertificate']
            if ($caCertBytes -and $caCertBytes.Count -gt 0) {
                $adCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @(,$caCertBytes[0])
                if (-not $chainCerts.ContainsKey($adCert.Thumbprint)) {
                    $chainCerts[$adCert.Thumbprint] = $adCert
                    Write-Host "    $($adCert.Subject) [from AD]" -ForegroundColor Green
                }
            }
        }
    }
} catch {
    Write-Host "  AD skipped: $($_.Exception.Message)" -ForegroundColor DarkGray
}

# ================================================================
# Export chain to PEM and update web.config
# ================================================================
Write-Host ""
Write-Host "Total CA chain certificates discovered: $($chainCerts.Count)" -ForegroundColor Cyan

if ($chainCerts.Count -gt 0) {
    if (-not $caConfig) {
        $firstCert = @($chainCerts.Values)[0]
        $caName = $firstCert.Subject -replace '^CN=([^,]+).*$', '$1'
        $caServer = $env:COMPUTERNAME
        $caConfig = "$caServer.$env:USERDNSDOMAIN\$caName"
    }
    Write-Host "CA Config: $caConfig" -ForegroundColor Green
    
    Write-Host "`nExporting chain certificates to $caStore..."
    $exported = 0
    foreach ($cert in $chainCerts.Values) {
        $certName = $cert.Subject -replace '^CN=([^,]+).*$', '$1'
        $certName = $certName -replace '[\\/:*?"<>|]', '_'
        $pemPath = Join-Path $caStore "$certName.pem"
        try {
            $pemContent = "-----BEGIN CERTIFICATE-----" + [Environment]::NewLine
            $pemContent += [System.Convert]::ToBase64String($cert.Export('Cert'), 'InsertLineBreaks')
            $pemContent += [Environment]::NewLine + "-----END CERTIFICATE-----" + [Environment]::NewLine
            Set-Content -Path $pemPath -Value $pemContent -Encoding ASCII
            Write-Host "  [+} $certName.pem ($($cert.Subject))" -ForegroundColor Green
            $exported++
        } catch {
            Write-Warning "  Failed: $certName - $($_.Exception.Message)"
        }
    }
    Write-Host "[+] Exported $exported PEM certificate(s) to CAStore." -ForegroundColor Green
} else {
    Write-Warning "No CA certificates discovered."
    $caConfig = 'FQDN\ISSUING-CA-NAME'
}

# Update web.config
if (Test-Path $webConfigPath) {
    [xml]$xml = Get-Content $webConfigPath
    if (-not $xml.configuration.appSettings) {
        $node = $xml.CreateElement("appSettings")
        $xml.configuration.AppendChild($node) | Out-Null
    }

    # CAStore
    $key = $xml.configuration.appSettings.add | Where-Object { $_.key -eq "CAStore" }
    if ($key) { $key.value = $caStore.ToString() } else {
        $e = $xml.CreateElement("add"); $e.SetAttribute("key","CAStore"); $e.SetAttribute("value",$caStore)
        $xml.configuration.appSettings.AppendChild($e) | Out-Null
    }

    # CAConfig
    $key = $xml.configuration.appSettings.add | Where-Object { $_.key -eq "CAConfig" }
    if ($key) { $key.value = $caConfig } else {
        $e = $xml.CreateElement("add"); $e.SetAttribute("key","CAConfig"); $e.SetAttribute("value",$caConfig)
        $xml.configuration.appSettings.AppendChild($e) | Out-Null
    }

    # LogPath
    $logPath = Join-Path $DestinationPath "logs\log.txt"
    $key = $xml.configuration.appSettings.add | Where-Object { $_.key -eq "LogPath" }
    if ($key) { $key.value = $logPath.ToString() } else {
        $e = $xml.CreateElement("add"); $e.SetAttribute("key","LogPath"); $e.SetAttribute("value",$logPath)
        $xml.configuration.appSettings.AppendChild($e) | Out-Null
    }

    # Ensure log directory exists
    $logDir = Split-Path $logPath -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
        Write-Host "[+] Created log directory: $logDir" -ForegroundColor Green
    }

    # Deployment GUID
    $entry = $xml.CreateElement("add")
    $entry.SetAttribute("key", $guid)
    $entry.SetAttribute("value", "1")
    $xml.configuration.appSettings.AppendChild($entry) | Out-Null

    $xml.Save($webConfigPath)
    Write-Host "[+] Web.config updated with CAConfig, CAStore, LogPath, GUID." -ForegroundColor Green
} else {
    Write-Error "Web.config not found at '$webConfigPath'."
}

# ============================================================
# 8 - Restart the app pool
# ============================================================
Write-Step "Step 8 - Restarting Application Pool"
Restart-WebAppPool -Name $appPoolName -ErrorAction SilentlyContinue
Write-Host "[+] App pool '$appPoolName' restarted." -ForegroundColor Green

# ============================================================
# 9 - Firewall rules
# ============================================================
Write-Step "Step 9 - Firewall Rules"
$fwRules = @(
    @{Name="WinCaApiEE HTTP (80)";  Port=80},
    @{Name="WinCaApiEE HTTPS (443)"; Port=443}
)
foreach ($rule in $fwRules) {
    $existing = Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
    if (-not $existing) {
        New-NetFirewallRule -DisplayName $rule.Name -Direction Inbound -Protocol TCP `
            -LocalPort $rule.Port -Action Allow -Profile Any | Out-Null
        Write-Host "[+] Firewall rule '$($rule.Name)' created." -ForegroundColor Green
    } else {
        Write-Host "[i] Firewall rule '$($rule.Name)' already exists." -ForegroundColor Gray
    }
}

# ============================================================
# 10 - Local hosts entry (optional)
# ============================================================
$addHosts = Read-Host "`nAdd $SiteDomain to local hosts file pointing to 127.0.0.1? (y/n, default: n)"
if ($addHosts -eq "y") {
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $current = Get-Content $hostsPath -Raw
    if ($current -notmatch [regex]::Escape($SiteDomain)) {
        Add-Content -Path $hostsPath -Value "`r`n127.0.0.1`t$SiteDomain" -Force
        Write-Host "[+] Added hosts entry: 127.0.0.1 $SiteDomain" -ForegroundColor Green
    }
}

# ============================================================
# 11 - Smoke test
# ============================================================
Write-Step "Step 10 - Smoke Test"
try {
    $resp = Invoke-WebRequest -Uri "http://127.0.0.1/" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    Write-Host "[OK] HTTP 200 OK - application is responding:" -ForegroundColor Green
    Write-Host "    $($resp.Content.Substring(0, [Math]::Min(200, $resp.Content.Length)))" -ForegroundColor Gray
}
catch {
    Write-Warning "Smoke test failed: $($_.Exception.Message)"
}

# ============================================================
# Summary
# ============================================================
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "            DEPLOYMENT COMPLETE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Website     : $siteName" -ForegroundColor White
Write-Host "  HTTP        : http://$SiteDomain" -ForegroundColor White
Write-Host "  HTTPS       : https://$SiteDomain" -ForegroundColor White
Write-Host "  App Pool    : $appPoolName" -ForegroundColor White
if ($appPoolUser) {
    Write-Host "  Identity    : $appPoolUser" -ForegroundColor White
}
Write-Host "  Files       : $DestinationPath" -ForegroundColor White
Write-Host "  Logs        : $logPath" -ForegroundColor White
Write-Host "  CA Certs    : $caStore" -ForegroundColor White
Write-Host "  CA Config   : $caConfig" -ForegroundColor White
if ($cert) {
    Write-Host "  Cert Thumb  : $($cert.Thumbprint)" -ForegroundColor White
}
Write-Host "================================================" -ForegroundColor Cyan

Write-Host "`n[!] Post-installation steps:" -ForegroundColor Yellow
Write-Host "    1. Add an A record for $SiteDomain pointing to this server in DNS" -ForegroundColor Yellow
Write-Host "    2. Verify the site responds to HTTPS requests" -ForegroundColor Yellow
Write-Host ""
