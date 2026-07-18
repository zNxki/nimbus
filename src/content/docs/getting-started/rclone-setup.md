---
title: Google Drive Setup (rclone)
description: Step-by-step guide to connecting Nimbus to your Google Drive account.
---

import { Steps, Aside } from '@astrojs/starlight/components';

Nimbus doesn't implement its own Google OAuth flow — it relies on [rclone](https://rclone.org/), which handles authentication securely and is already installed by the setup script. This page walks through connecting your Google account, including the extra step needed on a **headless server / VPS**.

## Start the guided setup

```bash
nimbus set GOOGLE_DRIVE
```

This launches `rclone config`. Follow along below.

## On a desktop with a browser

<Steps>

1. At the prompt `n) New remote`, type `n` and press Enter.

2. Give it a name, e.g.:
   ```
   name> gdrive
   ```

3. From the storage type list, find and select **Google Drive** (`drive`).

4. `client_id` → leave empty, press Enter (uses rclone's default).

5. `client_secret` → leave empty, press Enter.

6. `scope` → choose:
   ```
   1 / Full access all files, excluding Application Data Folder
   ```

7. `root_folder_id` → leave empty, press Enter.

8. `service_account_file` → leave empty, press Enter.

9. `Edit advanced config?` → `n`

10. `Use auto config?` → `y` — a browser tab opens; log in with the Google account you want to use and click **Allow**.

11. `Configure this as a Shared Drive (Team Drive)?` → `n` (unless you're using a company Shared Drive).

12. Confirm the summary with `y`, then `q` to quit the config menu.

</Steps>

Nimbus resumes automatically and asks which remote to use and which Drive folder to store backups in.

## On a headless VPS (no browser)

If you selected `n` at "Use auto config?" because your VPS has no browser, rclone prints something like:

```
Execute the following on the machine with the web browser (same rclone
version recommended):

    rclone authorize "drive"

Then paste the result below:
config_token>
```

<Steps>

1. On your **local machine** (the one with a browser), install rclone if needed:
   <Aside type="tip">
   Ubuntu/Debian: `sudo apt install rclone` · Arch: `sudo pacman -S rclone` · Fedora: `sudo dnf install rclone`
   </Aside>

2. Run:
   ```bash
   rclone authorize "drive"
   ```

3. A browser window opens (or a link is printed) — log in with your Google account and click **Allow**.

4. Your local terminal prints a JSON block:
   ```
   Paste the following into your remote machine --->
   {"access_token":"ya29...", "token_type":"Bearer", "refresh_token":"1//0g...", "expiry":"..."}
   <---End paste
   ```

5. Copy the **entire JSON string** (including the curly braces).

6. Back on the VPS, paste it at the `config_token>` prompt and press Enter.

</Steps>

rclone continues with the remaining questions (Shared Drive, summary confirmation) exactly as in the desktop flow above.

## Finishing up

After `rclone config` completes, Nimbus shows the list of configured remotes:

```
Available remotes:
  [0] gdrive:

Pick the remote to use for backups: 0
Google Drive folder name for backups (default: Backups):
```

Pick your remote and choose (or accept the default) folder name. Nimbus saves this as your backup destination.

Verify it worked:

```bash
nimbus list
```

You should see your remote listed under **Remote**. Next: [track your first directory and run a backup](/nimbus/getting-started/quick-start/).
