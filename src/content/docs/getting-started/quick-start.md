---
title: Quick Start
description: Track your first folder and run a backup in under a minute.
---

Once [installed](/nimbus/getting-started/installation/) and [connected to Google Drive](/nimbus/getting-started/rclone-setup/), here's the fastest path to your first backup.

## 1. Track a directory

```bash
nimbus add ~/Documents
```

Add as many as you like:

```bash
nimbus add /etc/nginx
nimbus add ~/projects/my-app
```

## 2. Run a backup now

```bash
nimbus run
```

Nimbus compresses each tracked directory into a `.tar.gz`, uploads it to your configured Google Drive folder, and deletes the local temporary archive.

## 3. Check the result

```bash
nimbus status
```

Shows your tracked directories, remote, schedule, and the last few log lines.

## 4. Automate it

```bash
nimbus each 6h
```

This schedules a backup every 6 hours via `cron`. Accepted units: `m` (minutes), `h` (hours), `d` (days) — e.g. `30m`, `2h`, `1d`.

## 5. (Optional) Exclude noisy folders

```bash
nimbus exclude add global node_modules
```

See the [Excludes guide](/nimbus/guides/excludes/) for per-directory rules.

---

That's it — you're backing up. Continue to the [Guides](/nimbus/guides/tracking-directories/) section for the full picture, or jump straight to the [Command Reference](/nimbus/reference/commands/).
