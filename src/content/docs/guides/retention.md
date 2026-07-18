---
title: Retention (Pruning Old Backups)
description: Automatically keep only the N newest backups per directory on the remote.
---

import { Aside } from '@astrojs/starlight/components';

Without retention, every `nimbus run` uploads a brand-new archive and nothing is ever removed —
old backups accumulate on Google Drive indefinitely. Retention lets Nimbus prune old archives
automatically, keeping only the newest N per tracked directory.

## Set a retention policy

```bash
nimbus retention set 5
```

This keeps only the 5 newest backups **per tracked directory** on the remote. It applies to every
directory tracked by Nimbus — there's no per-directory retention count, unlike excludes.

## Disable retention

```bash
nimbus retention clear
```

Backups accumulate again with no automatic cleanup.

## Check the current setting

```bash
nimbus retention show
```

`nimbus list` and `nimbus status` also show the current retention setting.

## How it works

Retention is applied automatically, right after each successful upload during `nimbus run` — there's
no separate "cleanup" command to run. For the directory that was just backed up, Nimbus:

1. Lists all archives on the remote whose filename starts with `<folder-name>_`
2. Sorts them by modification time, newest first
3. Deletes everything beyond the newest N

<Aside type="note">
Retention only runs as part of `nimbus run`. It does **not** apply to `nimbus sync` destinations,
since incremental sync mirrors a folder rather than creating discrete timestamped archives.
</Aside>

<Aside type="caution">
Deletions happen directly on the remote (`rclone deletefile`) — there's no local trash or undo.
Make sure the number you choose actually covers how far back you might need to restore from.
</Aside>

## Example

```bash
nimbus add ~/Documents
nimbus retention set 3
nimbus each 6h
```

After a few days, `gdrive:Backups` will only ever contain the 3 most recent `Documents_*.tar.gz`
(or `.tar.gz.gpg`, if [encryption](/nimbus/guides/encryption/) is also on) archives — older ones
are removed automatically as new ones land.
