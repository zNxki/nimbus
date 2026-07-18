# ☁️ Nimbus

**Ship your folders to the cloud, straight from your terminal.**
 
[![Version](https://img.shields.io/badge/version-1.2.0-blue?style=flat-square)](https://github.com/zNxki/nimbus/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/zNxki/nimbus/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/zNxki/nimbus/actions)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Downloads](https://img.shields.io/github/downloads/zNxki/nimbus/total?style=flat-square&color=orange)](https://github.com/zNxki/nimbus/releases)
[![Last Commit](https://img.shields.io/github/last-commit/zNxki/nimbus?style=flat-square)](https://github.com/zNxki/nimbus/commits/main)
[![Platform](https://img.shields.io/badge/platform-apt%20%7C%20pacman%20%7C%20dnf-lightgrey?style=flat-square)](#-installation-ubuntu-arch-fedora--derivatives)
[![Powered by rclone](https://img.shields.io/badge/powered%20by-rclone-2e7de6?style=flat-square)](https://rclone.org/)
 
Nimbus is a lightweight CLI tool for Ubuntu/Linux that backs up any directory to **Google Drive**, on demand or on a schedule — no bloated GUI, no subscription, just a fast script built on top of [rclone](https://rclone.org/).

```
 _   _ _           _
| \ | (_)_ __ ___ | |__  _   _ ___
|  \| | | '_ ` _ \| '_ \| | | / __|
| |\  | | | | | | | |_) | |_| \__ \
|_| \_|_|_| |_| |_|_.__/ \__,_|___/
      ship your files to the cloud
```

## ✨ Features

- 📁 Track any number of directories
- ☁️ Uploads securely to Google Drive via `rclone`
- ⏱️ Automatic scheduled backups (every N minutes/hours/days)
- 📦 Compresses to `.tar.gz` before upload
- ✅ Verifies each upload against the remote (size check) right after it lands
- 🔐 Optional GPG encryption of archives before they leave your machine
- 🗑️ Retention: automatically prune old backups, keeping only the N newest per directory
- 🔄 `nimbus sync` for incremental, non-archived mirroring (only changed files transfer)
- 🧪 `--dry-run` to preview what a backup would include/exclude, no upload
- 📜 Built-in logging (auto-rotated) and status dashboard
- ♻️ Restore: list backups, or download one directly with a single command

## 🚀 Installation (Ubuntu, Arch, Fedora & derivatives)

### One-liner (recommended)
 
```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash
```
 
This downloads and runs the installer directly — it auto-detects your package manager (`apt`, `pacman`, or `dnf`), installs `rclone` and `python3`, and places `nimbus` in `/usr/local/bin`.
 
If your shell has trouble with interactive prompts over a pipe, use process substitution instead:
> ```bash
> bash <(curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh)
> ```

### From a local clone

```bash
git clone https://github.com/zNxki/nimbus.git
cd nimbus
chmod +x nimbus install.sh
./install.sh install
```

### Managing the installation

Run without arguments for an interactive menu:

```bash
./install.sh
```
```
[1] INSTALL
[2] UPDATE
[3] UNINSTALL

Choice:
```

Or pass the action directly:

```bash
./install.sh install     # fresh install
./install.sh update      # checks the latest version; updates only if outdated, otherwise says "up-to-date"
./install.sh uninstall   # remove nimbus, the cron job, and (optionally) your config/logs
```

Via curl, pass the action after `-s --` (or omit it to get the interactive menu):

```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash -s -- update
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash -s -- uninstall
```

## 🔧 Setup

Connect your Google Drive account:

```bash
nimbus set GOOGLE_DRIVE
```

This walks you through rclone's guided OAuth flow — a browser window opens to authorize access.

## 📖 Usage

```bash
nimbus add <directory>       # Track a directory for backup
nimbus remove <directory>    # Stop tracking a directory
nimbus list                  # Show tracked directories, remote & schedule
nimbus run                   # Run a backup right now
nimbus run --dry-run         # Preview what would be archived/skipped, no upload
nimbus each 1h                # Schedule automatic backups (30m / 2h / 1d ...)
nimbus unschedule            # Remove the automatic schedule
nimbus status                # Show config + recent activity
nimbus log --lines 50        # Show the log
nimbus restore                        # List available backups on Drive
nimbus restore <file> [dest]          # Download a specific backup

nimbus exclude add <target> <pattern>    # Ignore files/folders (target: 'global' or a directory)
nimbus exclude remove <target> <pattern> # Stop ignoring a pattern
nimbus exclude list                      # Show global + per-directory exclude rules

nimbus retention set <n>     # Keep only the N newest backups per directory on the remote
nimbus retention clear       # Disable retention (keep everything)
nimbus retention show        # Show the current retention setting

nimbus set ENCRYPTION on     # Encrypt archives (GPG/AES256) before upload
nimbus set ENCRYPTION off    # Disable encryption

nimbus sync <directory>      # Incremental mirror straight to the remote (no re-archiving)
```

### 🔐 Encryption

```bash
nimbus set ENCRYPTION on
export NIMBUS_PASSPHRASE='your-secret-passphrase'   # required at backup time
nimbus run
```
Archives are encrypted locally with `gpg --symmetric --cipher-algo AES256` before they ever reach
Google Drive; the plaintext `.tar.gz` is deleted immediately after encryption. **Keep the
passphrase somewhere safe outside of Nimbus** — there is no recovery if you lose it.
To restore an encrypted backup:
```bash
nimbus restore myproject_20260101_0000.tar.gz.gpg
gpg --batch --passphrase-fd 0 -o myproject_20260101_0000.tar.gz -d myproject_20260101_0000.tar.gz.gpg
```

### 🗑️ Retention

```bash
nimbus retention set 5   # keep only the 5 newest backups per tracked directory
```
Older archives on the remote are deleted automatically right after each successful upload.

### 🔄 Incremental sync

`nimbus run` always makes a fresh full `.tar.gz` archive. For large or frequently-changing
directories, `nimbus sync <directory>` instead mirrors the folder straight to Drive with
`rclone sync`, transferring only what changed:
```bash
nimbus sync ~/Documents
```

By default, **global excludes** (applied to every tracked directory) already include `node_modules`, `.git`, `__pycache__`, `*.log`, `.DS_Store`.

You can also set **per-directory** excludes — handy when one project needs `node_modules` ignored and another doesn't:

```bash
nimbus add ~/projects/app1
nimbus add ~/projects/app2

nimbus exclude add ~/projects/app1 node_modules   # only ignored in app1
nimbus exclude add global "*.tmp"                 # ignored everywhere
```

Per-directory rules stack on top of the global ones. Patterns are glob-style and matched against filenames and folder names anywhere inside the tracked directory.

### Example

```bash
nimbus add ~/Documents
nimbus add /etc/nginx
nimbus set GOOGLE_DRIVE
nimbus each 6h
```

Every 6 hours, Nimbus compresses `~/Documents` and `/etc/nginx`, uploads them to your configured Google Drive folder, and logs the result — all in the background via cron.

## 🗂️ Where things live

| Path | Purpose |
|---|---|
| `~/.config/nimbus/config.json` | Configuration (tracked dirs, remote, schedule) |
| `~/.config/nimbus/nimbus.log` | Activity log |
| `~/.local/share/nimbus/staging/` | Temporary archives (auto-cleaned after upload) |

## 🛣️ Roadmap

- [x] Backup rotation / retention policy
- [x] Optional archive encryption before upload
- [x] Upload verification (size check against the remote)
- [x] Incremental backups via `nimbus sync`
- [ ] Support for additional cloud providers (S3, Dropbox, OneDrive)

## 📄 License

[Apache-2.0](LICENSE)