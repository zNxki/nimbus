---
title: Restoring Backups
description: How to find, download, and extract a previous backup archive.
---

import { Aside } from '@astrojs/starlight/components';

Nimbus doesn't overwrite your folder automatically — restoring is a deliberate, manual step
(safer than accidentally clobbering current work). `nimbus restore` handles listing and
downloading; extracting is a separate, explicit step you run yourself.

## List available backups

```bash
nimbus restore
```

This runs `rclone ls` against your configured remote and prints every archive available, e.g.:

```
  15839284 Documents_20260715_030000.tar.gz
  15914021 Documents_20260716_030000.tar.gz
  15920133 nginx_20260716_030000.tar.gz.gpg

To download one: nimbus restore <filename> [destination]
```

## Download an archive

```bash
nimbus restore <filename> [destination]
```

```bash
nimbus restore Documents_20260716_030000.tar.gz ~/restore-tmp/
```

Nimbus downloads the file directly (via `rclone copy`) into `destination`, or the current
directory if you omit it. On success, it confirms the file was restored; if the download fails,
the error from `rclone` is shown.

## Extract it

```bash
cd ~/restore-tmp
tar -xzvf Documents_20260716_030000.tar.gz
```

This creates a folder matching the original directory name, containing everything that was backed up at that point in time (minus anything matched by your exclude rules).

## Encrypted backups

If [encryption](/nimbus/guides/encryption/) was on when the backup was made, the filename ends in
`.gpg` and `nimbus restore` prints a decrypt hint after downloading it:

```bash
nimbus restore Documents_20260716_030000.tar.gz.gpg ~/restore-tmp/
```

```
✔ Restored 'Documents_20260716_030000.tar.gz.gpg' to ~/restore-tmp/
⚠ This backup is encrypted. Decrypt it with: gpg --batch --passphrase-fd 0 -o Documents_20260716_030000.tar.gz -d ~/restore-tmp/Documents_20260716_030000.tar.gz.gpg
```

Run the suggested `gpg` command (it will prompt for the passphrase on stdin), then extract the
resulting `.tar.gz` as usual.

<Aside type="caution">
You need the same passphrase that was set via `NIMBUS_PASSPHRASE` when the backup was created.
Nimbus never stores it — if you've lost it, the backup can't be decrypted.
</Aside>

## Tips

- Archive filenames are `<folder-name>_<YYYYMMDD>_<HHMMSS>.tar.gz` (or `.tar.gz.gpg` if encrypted) — sort by name to find the most recent one for a given folder.
- Extract to a **separate** temporary folder first, then copy back only what you need — avoid extracting directly over your live directory.
- If [retention](/nimbus/guides/retention/) is enabled, older archives are pruned automatically — only the newest N per directory will be listed here.
