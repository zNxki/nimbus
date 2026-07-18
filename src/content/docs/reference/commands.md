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

## `nimbus run`

Run a backup immediately, for all tracked directories.

```bash
nimbus run
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

## `nimbus restore`

List backups available on the configured remote, with a suggested `rclone copy` command to download one.

```bash
nimbus restore
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
