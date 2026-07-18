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

## A tracked directory keeps getting skipped

Nimbus logs `'<path>' no longer exists, skipping.` if a tracked path was deleted or moved. Update it with:

```bash
nimbus remove <old-path>
nimbus add <new-path>
```

<Aside type="tip">
Still stuck? Open an issue — see [Reporting Issues](/nimbus/contributing/reporting-issues/).
</Aside>
