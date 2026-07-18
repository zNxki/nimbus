---
title: Restoring Backups
description: How to find and download a previous backup archive.
---

Nimbus doesn't have a one-command "restore" that overwrites your folder automatically — backups are plain `.tar.gz` files sitting in your Google Drive folder, so restoring is a deliberate, manual step (safer than accidentally overwriting current work).

## List available backups

```bash
nimbus restore
```

This runs `rclone ls` against your configured remote and prints every archive available, e.g.:

```
  15839284 Documents_20260715_030000.tar.gz
  15914021 Documents_20260716_030000.tar.gz
  15920133 nginx_20260716_030000.tar.gz
```

## Download an archive

Use the command Nimbus suggests at the bottom of the output:

```bash
rclone copy gdrive:Backups/Documents_20260716_030000.tar.gz ~/restore-tmp/
```

## Extract it

```bash
cd ~/restore-tmp
tar -xzvf Documents_20260716_030000.tar.gz
```

This creates a folder matching the original directory name, containing everything that was backed up at that point in time (minus anything matched by your exclude rules).

## Tips

- Archive filenames are `<folder-name>_<YYYYMMDD>_<HHMMSS>.tar.gz` — sort by name to find the most recent one for a given folder.
- Extract to a **separate** temporary folder first, then copy back only what you need — avoid extracting directly over your live directory.
