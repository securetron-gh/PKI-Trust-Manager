# Enabling ACME on PKI Trust Manager — End-User Guide

This guide explains how to **enable ACME** on PKI Trust Manager and enroll
certificates using **acme.sh**, **certbot**, or **win-acme**.

---

## 1. How ACME works here

PKI Trust Manager exposes an RFC 8555 ACME server (part of CertAPI). Clients talk
to an ACME **directory** URL, register an account with **External Account Binding
(EAB)**, create an order for a domain, and receive a certificate issued by your CA.

```
ACME client ──https──▶ https://<acme-fqdn>/acme/directory   (nginx → CertAPI)
                              │ account (EAB) → order → finalize
                              ▼
                        CAProxy(ca.ApiUrl) → caapi → ADCS → certificate
```

- **EAB is required.** The directory advertises `externalAccountRequired: true`,
  and the server does not accept non-EAB accounts.
- Domain validation can be **auto-passed** (`RequireDomainValidation = 0` on the
  ACME app) or enforced via `http-01` / `dns-01`.

---

## 2. Admin setup — enable ACME on PKI Trust Manager

> Perform these steps once per ACME domain (in the Web Admin UI or by an admin).

1. **Create an ACME application**
   - Web Admin UI → Integrations → **New**
   - **Type**: ACME
   - -  **Domain**: the ACME hostname, e.g. `acme.secure.tron` (must match the Host
     header the client will send — no port)
   - **Certificate template**: pick a template bound to your CA (e.g.
     `Secure-WorkstationAuthentication` → `Secure-ISSUING-CA`)
   - **Require domain validation**: `Off` to auto-pass challenges, `On` for
     http-01/dns-01

2. **Create an ACME (EAB) user/entity**
   - Web Admin UI → Users → **Create** → type **ACME**
   - The UI generates and shows two values — save them:
     - **Key ID (KID)** — e.g. `58913e5c-1690-455c-9a73-834586af9daf`
     - **HMAC key** — e.g. `OTiuWblfcWUzzxCkk4lPbrCrgWSB-h26UmakHGy04Lk`
   - These are your client EAB credentials (`--eab-kid` / `--eab-hmac-key`).

3. **DNS**
   - Point the ACME FQDN at the PKI Trust Manager server:
     `acme.secure.tron → <server IP>`

4. **Reverse proxy (nginx) routing**
   - The ACME FQDN must be routed to CertAPI. If you deployed with the install
     script, add the FQDN to the ACME extras (`EXTRA_ACME_FQDNS` in `.env`, e.g.
     `acme,acme2,acme3,acme-eab.secure.tron`) and re-run the nginx update
     (deployment option 2 — Add or Modify FQDNs), or add it to
     `nginx.minimal.conf` server_name and recreate nginx.
   - Verify: `curl -k https://<acme-fqdn>/acme/directory` returns the ACME directory.

5. **Customer settings** (optional)
   - `Acme:Enabled = true` for the customer (default).
   - `CertificatePolicy:RequireApproval = false` for automatic issuance.

---

## 3. Client usage

> All examples use `acme-eab.secure.tron`, KID `58913e5c-1690-455c-9a73-834586af9daf`,
> HMAC `OTiuWblfcWUzzxCkk4lPbrCrgWSB-h26UmakHGy04Lk`. Replace with your values.

### 3a. acme.sh (Linux / macOS / Windows Git Bash)

```bash
# install (one time)
curl https://get.acme.sh | sh

# issue (use the http:// directory URL for lab setups with a self-signed cert;
# the directory advertises http:// URLs anyway)
~/.acme.sh/acme.sh --issue \
  --server http://acme-eab.secure.tron/acme/directory \
  -d acme-eab.secure.tron \
  --eab-kid 58913e5c-1690-455c-9a73-834586af9daf \
  --eab-hmac-key 'OTiuWblfcWUzzxCkk4lPbrCrgWSB-h26UmakHGy04Lk' \
  --webroot /tmp/acme-webroot \
  --keylength 2048 \
  --force

# certificates land in ~/.acme.sh/acme-eab.secure.tron/
# renew (acme.sh installs a cron/task automatically; or run --renew manually)
~/.acme.sh/acme.sh --renew -d acme-eab.secure.tron --force
```

### 3b. certbot (Linux / macOS / WSL2 on Windows)

```bash
# install: Debian/Ubuntu
sudo apt-get install -y certbot
# macOS: brew install certbot
# Windows: use WSL2 (certbot has no native Windows support)

# LAB ONLY — trust the PKI Trust Manager self-signed cert (certbot verifies TLS
# and has no insecure flag). Not needed with a real certificate.
sudo cp /opt/pki-trust-manager/certs/cert.crt /usr/local/share/ca-certificates/pki-tm.crt
sudo update-ca-certificates

# issue (EAB + RSA 2048 are required — certbot defaults to ECDSA, which the
# ADCS template rejects)
sudo certbot certonly --manual --preferred-challenges http \
  --server https://acme-eab.secure.tron/acme/directory \
  -d acme-eab.secure.tron \
  --eab-kid 58913e5c-1690-455c-9a73-834586af9daf \
  --eab-hmac-key 'OTiuWblfcWUzzxCkk4lPbrCrgWSB-h26UmakHGy04Lk' \
  --key-type rsa --rsa-key-size 2048 \
  --manual-auth-hook 'true' \
  --agree-tos -m admin@secure.tron -n

# certificates land in /etc/letsencrypt/live/acme-eab.secure.tron/
# (certbot installs an automatic renewal task)
```

### 3c. win-acme (Windows native)

```powershell
# download + extract win-acme (no installer):
#   https://github.com/win-acme/win-acme/releases  (win-acme.v2.2.9.1701.x64.trimmed.zip)

# LAB ONLY — trust the PKI Trust Manager self-signed cert in the Windows store:
Import-Certificate -FilePath cert.crt -CertStoreLocation Cert:\CurrentUser\Root

# issue (filesystem validation avoids needing admin; the server auto-passes)
.\wacs.exe --source manual --host acme-eab.secure.tron `
  --baseuri https://acme-eab.secure.tron/acme/directory `
  --eab-key-identifier 58913e5c-1690-455c-9a73-834586af9daf `
  --eab-key OTiuWblfcWUzzxCkk4lPbrCrgWSB-h26UmakHGy04Lk `
  --validation filesystem --webroot C:\certs\acmewebroot `
  --store pemfiles --pemfilespath C:\certs `
  --accepttos --emailaddress admin@secure.tron --notaskscheduler

# certificates exported to C:\certs\ (acme-eab.secure.tron-crt.pem, -key.pem, -chain.pem)
```

---

## 4. Verify

```bash
# the issued certificate
openssl x509 -in <cert-file> -noout -subject -issuer -dates -ext subjectAltName
# expect: CN/SAN = your ACME domain, issuer = your CA (e.g. Secure-ISSUING-CA)
```

In the Web Admin UI, the enrollment appears in **Certificates** with status
**Issued**.

---

## 5. Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `externalAccountRequired` / EAB errors | Use valid `--eab-kid` / `--eab-hmac-key` from the ACME user |
| `serverInternal` on account creation | The non-EAB path is not supported — always use EAB |
| certbot: `denied by the CA` | certbot defaulted to an ECDSA key — add `--key-type rsa --rsa-key-size 2048` |
| acme.sh: `curl error 60` | self-signed TLS cert — use the `http://` directory URL (lab) or trust the cert |
| certbot/win-acme: TLS verify fails | Import the self-signed cert into the trust store (lab only) |
| 443 serves the Web UI instead of ACME | ACME FQDN missing from nginx server_name — add it to `EXTRA_ACME_FQDNS` and update nginx |
| `unauthorized` on new-order | customer `Acme:Enabled` is false |
| key-size denial | ADCS template minimum key size — use RSA 2048 |
| win-acme: "Run as administrator" | SelfHosting validation needs admin — use `--validation filesystem` instead |
| win-acme: renewal-info error | non-blocking server-side bug in the image; certificate is still issued |

---

## 6. Reference — ACME endpoints

| Endpoint | Port |
|---|---|
| `https://<fqdn>/acme/directory` | 443 |
| `https://<fqdn>:8556/acme/directory` | 8556 (dedicated ACME local port) |
| `http://<fqdn>/acme/directory` | 80 (directory advertises `http://` URLs) |
