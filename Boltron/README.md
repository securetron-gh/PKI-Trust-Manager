# Boltron

Boltron is the PKI Trust Manager agent for Windows. It inspects the servers you approve, reports certificates and the software that serves them, and applies approved certificate changes. It works with on-premises and SaaS PKI Trust Manager installations.

## Download

| Version | Package | Checksums |
|---|---|---|
| 2.3.0 | [Boltron-2.3.0-win-x64.zip](https://github.com/securetron-gh/PKI-Trust-Manager/releases/download/boltron-2.3.0/Boltron-2.3.0-win-x64.zip) | [SHA256SUMS](https://github.com/securetron-gh/PKI-Trust-Manager/releases/download/boltron-2.3.0/SHA256SUMS) |

The package includes the .NET runtime; nothing else needs installing.

Check the download before you extract it. Compare the SHA-256 of the zip with `SHA256SUMS` from the same release:

```powershell
(Get-FileHash .\Boltron-2.3.0-win-x64.zip -Algorithm SHA256).Hash.ToLower()
```

This release is not code-signed yet, so Windows SmartScreen may warn when you run `Boltron.exe`. Verify the SHA-256 hash as above before you run it. A signed release will follow.

## Requirements

- Windows Server 2016 or later, or Windows 10 or later, x64.
- A PKI Trust Manager organization with Agents enabled, and the application ID, key and login certificates for the agent.
- HTTPS access from the machine to your PKI Trust Manager address.

## Next

- [User guide](docs/guide.md): install, register, set up targets, run as a service, upgrade.
- [Changelog](CHANGELOG.md)

Use an agent version your server supports. The portal lists the agent versions in use under Monitoring.
