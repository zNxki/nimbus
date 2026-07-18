---
title: Incremental Sync
description: Mirror a tracked directory straight to the remote, transferring only what changed.
---

import { Aside } from '@astrojs/starlight/components';

`nimbus run` always builds a fresh, full `.tar.gz` archive of every tracked directory — simple and
safe, but it re-uploads everything each time, even unchanged files. For large or frequently
changing directories, `nimbus sync` mirrors the folder straight to your remote with `rclone sync`
instead, transferring only what changed since the last sync.

## Usage

```bash
nimbus sync <directory>
```

The directory must already be [tracked](/nimbus/guides/tracking-directories/) with `nimbus add`,
and a remote must be [configured](/nimbus/getting-started/rclone-setup/).

```bash
nimbus add ~/Documents
nimbus sync ~/Documents
```

## Where it goes

Unlike `nimbus run`, which uploads timestamped archives directly into your configured remote
folder, `nimbus sync` mirrors into a dedicated subfolder named after the directory, suffixed
`-sync`:

```
gdrive:Backups/Documents-sync/
```

This keeps synced mirrors clearly separate from `nimbus run`'s timestamped archives.

## Excludes still apply

Both global and per-directory [exclude rules](/nimbus/guides/excludes/) are honored, translated
into `rclone`'s own `--filter` syntax under the hood.

<Aside type="note">
`nimbus sync` is a true mirror: files deleted locally are also removed from the remote copy on the
next sync. This is different from `nimbus run`, which only ever adds new archives.
</Aside>

<Aside type="caution">
[Retention](/nimbus/guides/retention/) and [encryption](/nimbus/guides/encryption/) apply only to
`nimbus run`'s timestamped archives — they don't affect `nimbus sync` destinations.
</Aside>

## Choosing between `run` and `sync`

| | `nimbus run` | `nimbus sync <dir>` |
|---|---|---|
| Transfers | Full archive every time | Only changed files |
| Format on remote | Timestamped `.tar.gz` (or `.gpg`) | Live mirror of the folder |
| Encryption | Supported | Not supported |
| Retention | Supported | Not applicable |
| Good for | Point-in-time snapshots you can restore individually | Large/frequently-changing folders where you just want an up-to-date copy |
