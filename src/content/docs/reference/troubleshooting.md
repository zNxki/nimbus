---
title: Troubleshooting
description: Common issues and how to fix them.
---

import { Aside } from '@astrojs/starlight/components';

## "Invalid choice" in the install menu

**Cause:** you ran the installer with `curl ... | bash`, and your shell doesn't keep stdin free for keyboard input over a pipe.

**Fix:** use process substitution instead:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh)
```

Recent versions of `install.sh` also read menu/confirmation prompts from `/dev/tty` directly, which fixes this for standard `curl | bash` too. Make sure you're on the latest version (`nimbus --version`).

## `'rclone' is not installed`

Nimbus requires `rclone` to talk to Google Drive. If the installer couldn't detect your package manager, install it manually:

```bash
# Ubuntu/Debian
sudo apt install rclone

# Arch
sudo pacman -S rclone

# Fedora
sudo dnf install rclone
```

## `No remote configured. Run: nimbus set GOOGLE_DRIVE`

You haven't connected a Google Drive account yet. See [Google Drive Setup](/nimbus/getting-started/rclone-setup/).

## Stuck at `config_token>` during setup

You're on a headless server. You need to run `rclone authorize "drive"` on a **different machine that has a browser**, then paste the resulting JSON back into the VPS prompt. Full walkthrough: [Google Drive Setup — headless VPS](/nimbus/getting-started/rclone-setup/#on-a-headless-vps-no-browser).

## Backup runs but nothing appears on Google Drive

- Check `nimbus log` for upload errors — a failed `rclone copy` is logged with the reason.
- Confirm your remote is correct: `nimbus list` should show something like `gdrive:Backups`.
- Test rclone directly: `rclone ls gdrive:Backups` (replace with your remote name).

## Scheduled backups aren't running

- Confirm the cron entry exists: `crontab -l | grep NIMBUS`
- Check that `cron` (or `cronie` on Arch) is installed and running:
  ```bash
  systemctl status cron      # Debian/Ubuntu
  systemctl status cronie    # Arch
  systemctl status crond     # Fedora
  ```
- Re-create the schedule: `nimbus each 6h`

## `Encryption is enabled but NIMBUS_PASSPHRASE is not set`

You turned encryption on (`nimbus set ENCRYPTION on`) but didn't export the passphrase in the
shell (or cron environment) where the backup is actually running:

```bash
export NIMBUS_PASSPHRASE='your-secret-passphrase'
```

If this happens on a **scheduled** run via `nimbus each`, remember cron doesn't inherit your
interactive shell's environment — the variable needs to be set wherever cron picks up its
environment (e.g. directly in the crontab). See [Encryption](/nimbus/guides/encryption/).

## `'gpg' is not installed but encryption is enabled`

Install GnuPG manually:

```bash
# Ubuntu/Debian
sudo apt install gnupg

# Arch
sudo pacman -S gnupg

# Fedora
sudo dnf install gnupg
```

## Upload succeeded but logged a size mismatch

Nimbus checks the uploaded file's size against Google Drive right after upload. A mismatch
usually means a flaky connection during upload — re-run `nimbus run` for that directory. If it
persists, test the upload manually with `rclone copy <file> <remote> -v` for more detail.

## A tracked directory keeps getting skipped

Nimbus logs `'<path>' no longer exists, skipping.` if a tracked path was deleted or moved. Update it with:

```bash
nimbus remove <old-path>
nimbus add <new-path>
```

<Aside type="tip">
Still stuck? Open an issue — see [Reporting Issues](/nimbus/contributing/reporting-issues/).
</Aside>
