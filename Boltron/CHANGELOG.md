# Changelog

## 2.3.0

First public release. It contains everything built since the agent's first versions.

### Checking servers

- Check Linux hosts over SSH and Windows hosts over WinRM or locally, including through a SOCKS5 proxy. Each run uses its own SSH route.
- Probe every address of a subnet target, skip addresses that do not answer, and keep results between cycles until the scan interval passes.
- Find certificates in files, Java keystores and the Windows certificate stores, including the Web Hosting store, and read certificates IIS serves.
- Report which web servers run on a Linux host, and detect local web servers and automation tools from services and the process table.
- Collect post-quantum facts on Linux and Windows hosts.
- Wait for a busy server instead of failing a check or an apply.
- Keep results fresh: surveys refresh after policy changes and manual checks.

### Exploration

- Explore each target with steps chosen by the server; the agent only runs them. Every step is recorded before it runs.
- Reading commands are labelled read-only only when they are. Output and configuration secrets are redacted and bounded.
- Learned scope rules and evidence-backed findings narrow later surveys.

### Certificate changes

- Request an ACME certificate for an IIS site with a dry run, exact-plan approval, apply, verification and automatic rollback.
- Find win-acme renewals wherever win-acme keeps them, and attribute a Windows store certificate to win-acme only when its renewal file names it.
- Issue and install certificates into nginx on Linux hosts, including a containerized nginx site, end to end.
- Register the ACME account in a prepared dry run.
- Plan a keystore renewal from a sign-in without root instead of failing.

### Operating Boltron

- Interactive launcher for setup, testing, starting and status. Secrets are entered at secure prompts.
- Run as a Windows Service or a scheduled task. A single-instance guard protects the data directory.
- Sign the agent in again when its API sign-in expires. Send the last cycle's outcome with every heartbeat.
- Say why a check stopped, in operator words, with the agent and time, and report an older agent that could not sign in to or reach a server.
- Redacted JSON diagnostics in `logs\run.log`, rotated at 10 MiB.

### Packaging

- This release is not code-signed. `SHA256SUMS` accompanies each release; verify the download against it.
