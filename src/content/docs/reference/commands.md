---
title: Command Reference
description: Every nimbus command, with usage and options.
---

## `nimbus add <directory>`

Track a directory for backup.

```bash
nimbus add ~/Documents
```

## `nimbus remove <directory>`

Stop tracking a directory. Doesn't delete existing backups.

```bash
nimbus remove ~/Documents
```

## `nimbus list`

List all tracked directories, their per-directory excludes, the configured remote, and the schedule.

```bash
nimbus list
```

## `nimbus set GOOGLE_DRIVE`

Launches the guided `rclone` setup to connect a Google Drive account. See the [rclone setup guide](/nimbus/getting-started/rclone-setup/).

```bash
nimbus set GOOGLE_DRIVE
```

## `nimbus set ENCRYPTION <on|off>`

Turns GPG/AES256 archive encryption on or off. See the [Encryption guide](/nimbus/guides/encryption/).

```bash
nimbus set ENCRYPTION on
nimbus set ENCRYPTION off
```

## `nimbus run`

Run a backup immediately, for all tracked directories. After each upload, Nimbus checks the
file's size on the remote against the local size and logs a warning/error if they don't match.

```bash
nimbus run
```

## `nimbus run --dry-run`

Preview what would be archived/skipped for every tracked directory, without creating an archive
or touching the remote. See the [Dry-Run guide](/nimbus/guides/dry-run/).

```bash
nimbus run --dry-run
```

## `nimbus sync <directory>`

Incrementally mirror one tracked directory straight to the remote with `rclone sync` — only
changed files transfer, no re-archiving. See the [Incremental Sync guide](/nimbus/guides/incremental-sync/).

```bash
nimbus sync ~/Documents
```

## `nimbus each <time>`

Schedule automatic backups via cron. `<time>` accepts `m` (minutes), `h` (hours), `d` (days).

```bash
nimbus each 6h
```

## `nimbus unschedule`

Remove the automatic backup schedule.

```bash
nimbus unschedule
```

## `nimbus status`

Show a summary: number of tracked directories, remote, schedule, and the last 5 log lines.

```bash
nimbus status
```

## `nimbus log [--lines N]`

Print the log file. Defaults to the last 20 lines.

```bash
nimbus log --lines 50
```

## `nimbus retention set <n>`

Keep only the N newest backups per tracked directory on the remote; older ones are deleted
automatically after each successful upload. See the [Retention guide](/nimbus/guides/retention/).

```bash
nimbus retention set 5
```

## `nimbus retention clear`

Disable retention (keep every backup, unlimited).

```bash
nimbus retention clear
```

## `nimbus retention show`

Show the current retention setting.

```bash
nimbus retention show
```

## `nimbus restore [filename] [destination]`

With no arguments, lists backups available on the configured remote. With a filename, downloads
that archive (via `rclone copy`) into `destination`, or the current directory if omitted. See
[Restoring Backups](/nimbus/guides/restoring/).

```bash
nimbus restore
nimbus restore Documents_20260716_030000.tar.gz ~/restore-tmp/
```

## `nimbus exclude add <target> <pattern>`

Add an exclude pattern. `<target>` is either `global` (applies to all directories) or the path of a tracked directory.

```bash
nimbus exclude add global node_modules
nimbus exclude add ~/projects/app1 dist
```

## `nimbus exclude remove <target> <pattern>`

Remove a previously added exclude pattern.

```bash
nimbus exclude remove global node_modules
```

## `nimbus exclude list`

Show all global and per-directory exclude rules.

```bash
nimbus exclude list
```

## `nimbus --version`

Print the installed version.

## `nimbus --help`

Show the full list of commands.
