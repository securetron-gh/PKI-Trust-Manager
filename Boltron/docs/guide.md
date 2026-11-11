# Boltron user guide

## Install

1. Download `Boltron-<version>-win-x64.zip` and `SHA256SUMS` from the release for your version. Confirm the hash matches.
2. Extract the zip to a folder owned by the Windows account that will run Boltron.
3. Choose a private folder outside the extracted package for the configuration, certificates and data. Keep that folder across upgrades.

## Configure

Run the launcher from PowerShell as the account that will run Boltron:

```powershell
.\start-boltron.ps1
```

- **New setup.** Enter your PKI Trust Manager HTTPS address, the application ID and key, and the login certificate (PFX) and its password. Do this separately for the Agent profile and the Operator profile. Then choose a data directory. Add the public root certificate files of a private CA if you use one; TLS checks stay on. Type `SAVE` to finish.
- **Edit setup.** Press Enter to keep a value without showing it. Type `SAVE` to replace the configuration. A restricted `.bak` file keeps the previous one. It holds credentials, so keep it private.
- **Test connection.** Checks operator access. Testing the agent asks you to type `YES` because its heartbeat can create the first identity or a pending registration.
- **Start.** Type `START` to run the agent in the console. Press Ctrl+C to stop. Never start two instances on the same data directory.
- **Status.** Shows whether a configuration exists and the Windows Service state.

Secrets are entered at secure prompts, never on the command line. The configuration file is protected by Windows file permissions. Use separate machine (Agent) and human (Operator) certificates, and keep operator credentials out of an unattended agent's configuration.

You can also copy `boltron.example.json` from the extracted package into your private folder and fill it in. Environment variables override it with the `BOLTRON_` prefix and double underscores, for example `BOLTRON_Agent__APIProvider__AppKey`.

## Register the agent

```powershell
.\Boltron.exe --version
.\Boltron.exe register --config C:\Private\Boltron\agent.json
.\Boltron.exe agent-status --config C:\Private\Boltron\agent.json
.\Boltron.exe run --once --config C:\Private\Boltron\agent.json
.\Boltron.exe run --config C:\Private\Boltron\agent.json
```

Registration creates a pending request. In the portal, open Monitoring, find the agent under **Waiting for setup**, and follow its setup steps: activate the agent binding, its certificate credential and inventory grant, then assign a Boltron policy through tags. An administrator must also enable Agents for the organization, and the central AI features if you want them.

The agent keeps its identity in `.agent-id` in the data directory. Keep that directory and the same Windows account across upgrades.

## Choose what Boltron checks

The Boltron policy in the portal sets the targets, certificate paths, collectors, scan interval, concurrency and timeouts. Each target has a host name, a transport and the folders to read:

- **Local**: the machine Boltron runs on.
- **Ssh**: needs a verified SHA-256 host-key fingerprint and Python 3 on the target.
- **WinRm**: needs Windows PowerShell and HTTPS with a trusted server certificate.

Credentials for remote targets are granted centrally. Boltron receives short-lived credentials per operation; they are not stored on the agent.

Collectors read platform details, public certificates, which applications and web servers run, and probe the HTTPS endpoints you list. They install nothing and change nothing. Anything missing or unreadable is reported as such.

## Exploration

When exploration is on for a policy, Boltron explores each target after the collectors. The server chooses every step and Boltron only runs it. Every step is recorded before it runs and shown on the Activity page with secrets redacted. A session is limited to 40 steps. Only `apply_change` can modify a host, and an operator must approve its exact arguments within 30 minutes.

## Certificate changes

When the policy allows actions and the organization has enabled them, an administrator can request an ACME certificate for an IIS site.

1. **Dry run.** Boltron checks the host without changing it: administrator rights, IIS, the site, port 80 bindings, win-acme 2.2 or later, ACME reachability and current bindings. The server turns the result into a plan with a hash.
2. **Approval.** An administrator approves that exact plan within 30 minutes.
3. **Apply.** Boltron re-checks the host, refuses if anything changed, runs win-acme against the approved directory, binds the certificate in IIS and keeps scheduled renewal.
4. **Verification.** Boltron confirms the new certificate is on every HTTPS binding. On failure it restores the previous bindings and reports `RolledBack`, or `NeedsAttention` if restoring fails.

Boltron does not install win-acme or IIS. Applying needs administrator rights, so run the agent as a Windows Service on hosts it changes.

## Operator commands

```powershell
.\Boltron.exe hosts --config C:\Private\Boltron\operator.json
.\Boltron.exe host <host-id> --config C:\Private\Boltron\operator.json
.\Boltron.exe scans <host-id> --config C:\Private\Boltron\operator.json
.\Boltron.exe verdict <host-id> <scan-id> --config C:\Private\Boltron\operator.json
.\Boltron.exe chat --config C:\Private\Boltron\operator.json
.\Boltron.exe actions --target <target-id> --config C:\Private\Boltron\operator.json
.\Boltron.exe approve <action-id> --config C:\Private\Boltron\operator.json
```

In a terminal, commands print tables; when output is redirected or with `--json`, they print JSON. `.\Boltron.exe --help` lists every command.

## Run in the background

- **Windows Service** (needed for certificate changes): from an elevated PowerShell, run `install-service.ps1 -ConfigurationPath C:\Private\Boltron\agent.json`. It starts with Windows and restarts after failures. It runs as LocalSystem unless you pass `-Account DOMAIN\boltron$` for a group managed service account that is a local administrator. `uninstall-service.ps1` removes it and keeps your configuration and data.
- **Scheduled task** (read-only checks): `install-background.ps1 -ConfigurationPath C:\Private\Boltron\agent.json`. It runs under the current account and cannot apply changes that need administrator rights. `uninstall-background.ps1` removes it.

Switch between the service and the task only after a clean `run --once` leaves no pending work, because recovery data is protected per account.

## Logs

`run` prints timestamps and readable steps. Use `--json` for machine-readable lines or `--debug` for correlation IDs. Redacted events are also written to `logs\run.log` in the data directory; it rotates at 10 MiB and keeps five archives. Host names and paths can still be sensitive, so keep the folder private.

## Upgrade

1. Run `uninstall-service.ps1` or `uninstall-background.ps1` from the old package.
2. Keep your private configuration, certificates and data directory.
3. Extract the new release to its own folder and run its installer.

Interrupted operations resume on the next run. A scan that started without saved evidence is reported as `outcome_unknown`; Boltron does not repeat host operations silently.
