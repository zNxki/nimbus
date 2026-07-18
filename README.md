# ☁️ Nimbus

**Ship your folders to the cloud, straight from your terminal.**

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
- 📜 Built-in logging and status dashboard
- ♻️ Easy restore listing

## 🚀 Installation (Ubuntu, Arch, Fedora & derivatives)

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash
```

This downloads and runs the installer directly — it auto-detects your package manager (`apt`, `pacman`, or `dnf`), installs `rclone` and `python3`, and places `nimbus` in `/usr/local/bin`.

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
nimbus each 1h                # Schedule automatic backups (30m / 2h / 1d ...)
nimbus unschedule            # Remove the automatic schedule
nimbus status                # Show config + recent activity
nimbus log --lines 50        # Show the log
nimbus restore               # List available backups on Drive

nimbus exclude add <target> <pattern>    # Ignore files/folders (target: 'global' or a directory)
nimbus exclude remove <target> <pattern> # Stop ignoring a pattern
nimbus exclude list                      # Show global + per-directory exclude rules
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

- [ ] Backup rotation / retention policy
- [ ] Optional archive encryption before upload
- [ ] Support for additional cloud providers (S3, Dropbox, OneDrive)

## 📄 License

[Apache-2.0](LICENSE)