---
title: Tracking Directories
description: How to add, remove, and list backed-up directories.
---

Nimbus keeps a list of directories it backs up. You manage this list with `add`, `remove`, and `list`.

## Add a directory

```bash
nimbus add <directory>
```

Example:

```bash
nimbus add ~/Documents
nimbus add /etc/nginx
```

Paths are resolved to their absolute form, so `~/Documents` and `/home/you/Documents` are treated as the same directory.

## Remove a directory

```bash
nimbus remove <directory>
```

This stops tracking it — it does **not** delete anything already uploaded to Google Drive.

## List tracked directories

```bash
nimbus list
```

Output includes each directory, its per-directory excludes (if any), the configured remote, and the current schedule.

## What happens at backup time

Every tracked directory is:

1. Compressed into `<folder-name>_<timestamp>.tar.gz`
2. Encrypted, if [encryption](/nimbus/guides/encryption/) is turned on (producing a `.gpg` file instead)
3. Uploaded to your configured Google Drive remote
4. Verified — Nimbus checks the uploaded file's size against the remote
5. Deleted locally (the temporary archive, not the original folder!)
6. Pruned per your [retention](/nimbus/guides/retention/) setting, if any

If a tracked directory no longer exists on disk when a backup runs, Nimbus logs a warning and skips it — it won't fail the whole run.

For large or frequently-changing directories, [`nimbus sync`](/nimbus/guides/incremental-sync/) is an alternative to this archive-based flow — it mirrors the directory straight to the remote instead.
