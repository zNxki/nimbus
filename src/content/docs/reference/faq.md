---
title: FAQ
description: Frequently asked questions about Nimbus.
---

### Does Nimbus support cloud providers other than Google Drive?

Not yet — Nimbus is currently focused on Google Drive. Since it's built on [rclone](https://rclone.org/), which supports dozens of providers, additional backends (S3, Dropbox, OneDrive) are on the roadmap.

### Is my data encrypted before upload?

Not currently. Archives are uploaded as plain `.tar.gz` over rclone's HTTPS connection to Google (in transit encryption), but not encrypted at rest client-side. Encryption before upload is on the roadmap — track it in the repo's issues.

### Does Nimbus deduplicate or version backups?

No. Every run creates a brand-new timestamped archive. There's no retention policy or automatic cleanup yet (also on the roadmap) — old archives on Drive will accumulate until you remove them manually or via `rclone delete`.

### Can I back up to a Shared Drive (Team Drive)?

Yes — during `rclone config`, answer `y` to "Configure this as a Shared Drive?" and follow the prompts.

### Can I run Nimbus without cron?

Yes — `nimbus run` works standalone at any time. Scheduling via `nimbus each` is just a convenience wrapper around cron; you could equally call `nimbus run` from any other scheduler (systemd timers, CI pipelines, etc.).

### Does Nimbus work over SSH / on a headless server?

Yes, that's a primary use case. The one extra step is authorizing rclone without a local browser — see [Google Drive Setup — headless VPS](/nimbus/getting-started/rclone-setup/#on-a-headless-vps-no-browser).

### What happens if two backups overlap (a long-running one and a scheduled one)?

Nimbus doesn't currently lock against concurrent runs. Avoid scheduling backups more frequently than they take to complete, especially for large directories.

### How do I completely remove Nimbus and start fresh?

```bash
./install.sh uninstall
```

Say "yes" when asked whether to delete config and logs too.

### Where can I ask something not covered here?

Open a [GitHub Discussion or Issue](https://github.com/zNxki/nimbus/issues) — see [Reporting Issues](/nimbus/contributing/reporting-issues/).
