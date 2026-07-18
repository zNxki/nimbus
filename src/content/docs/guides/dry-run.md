---
title: Dry-Run Mode
description: Preview what a backup would include or skip, without uploading anything.
---

Before running a real backup — especially after changing excludes, or adding a new large
directory — you can preview exactly what would happen with `--dry-run`.

## Usage

```bash
nimbus run --dry-run
```

For every tracked directory, Nimbus walks the filesystem and reports how many files would be
archived versus skipped, without creating an archive, encrypting anything, or touching the
remote at all:

```
~/Documents -> would archive 1204 files, skip 37 files (excludes: node_modules, .git, __pycache__, *.log, .DS_Store)
~/projects/app1 -> would archive 856 files, skip 412 files (excludes: node_modules, .git, __pycache__, *.log, .DS_Store, dist)
Dry run complete. No files were uploaded.
```

The exclude list shown for each directory is the combined global + per-directory rules — see
[Excluding Files & Folders](/nimbus/guides/excludes/).

## What it doesn't require

Unlike a real `nimbus run`, `--dry-run` doesn't need `rclone` installed or a remote configured —
it's a purely local check, so it's safe to run at any point, even before finishing setup.

## What it doesn't check

Dry-run counts files against your exclude patterns; it doesn't estimate archive size, upload
time, or catch upload-side failures. For a true incremental preview of a folder (e.g. before an
`nimbus sync`), use `rclone sync --dry-run` directly.
