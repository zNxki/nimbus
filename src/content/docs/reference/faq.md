---
title: FAQ
description: Frequently asked questions about Nimbus.
---

### Does Nimbus support cloud providers other than Google Drive?

Not yet — Nimbus is currently focused on Google Drive. Since it's built on [rclone](https://rclone.org/), which supports dozens of providers, additional backends (S3, Dropbox, OneDrive) are on the roadmap.

### Is my data encrypted before upload?

By default, archives are uploaded as plain `.tar.gz` over rclone's HTTPS connection to Google (in transit encryption), but not encrypted at rest client-side. You can turn on optional GPG/AES256 client-side encryption with `nimbus set ENCRYPTION on` — see [Encryption](/nimbus/guides/encryption/).

### Does Nimbus deduplicate or version backups?

No deduplication — every `nimbus run` creates a brand-new timestamped archive. You can cap how many pile up with [retention](/nimbus/guides/retention/) (`nimbus retention set <n>`), which automatically prunes older archives per directory; without it, backups accumulate until you remove them manually or via `rclone delete`. For a de-duplicated mirror instead of discrete archives, use [`nimbus sync`](/nimbus/guides/incremental-sync/).

### Can I back up to a Shared Drive (Team Drive)?

Yes — during `rclone config`, answer `y` to "Configure this as a Shared Drive?" and follow the prompts.

### Can I run Nimbus without cron?

Yes — `nimbus run` works standalone at any time. Scheduling via `nimbus each` is just a convenience wrapper around cron; you could equally call `nimbus run` from any other scheduler (systemd timers, CI pipelines, etc.).

### Does Nimbus work over SSH / on a headless server?

Yes, that's a primary use case. The one extra step is authorizing rclone without a local browser — see [Google Drive Setup — headless VPS](/nimbus/getting-started/rclone-setup/#on-a-headless-vps-no-browser).

### What happens if two backups overlap (a long-running one and a scheduled one)?

Nimbus doesn't currently lock against concurrent runs. Avoid scheduling backups more frequently than they take to complete, especially for large directories.

### Does Nimbus verify that an upload actually landed correctly?

Yes — right after each upload, Nimbus compares the file's size on Google Drive against the local
size and logs a warning if it can't verify, or an error if the sizes don't match.

### How do I completely remove Nimbus and start fresh?

```bash
./install.sh uninstall
```

Say "yes" when asked whether to delete config and logs too.

### Where can I ask something not covered here?

Open a [GitHub Discussion or Issue](https://github.com/zNxki/nimbus/issues) — see [Reporting Issues](/nimbus/contributing/reporting-issues/).
