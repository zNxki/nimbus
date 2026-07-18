---
title: Scheduling Backups
description: Automate backups with cron using nimbus each.
---

import { Aside } from '@astrojs/starlight/components';

## Set a schedule

```bash
nimbus each <time>
```

Where `<time>` is a number followed by a unit:

| Unit | Meaning | Example |
|---|---|---|
| `m` | minutes | `nimbus each 30m` |
| `h` | hours | `nimbus each 6h` |
| `d` | days | `nimbus each 1d` |

This writes a `cron` entry that runs `nimbus run` on the given interval — Nimbus doesn't need to stay running in the background; `cron` handles it.

## Remove the schedule

```bash
nimbus unschedule
```

## Check the current schedule

```bash
nimbus status
```

or

```bash
nimbus list
```

Both show the active schedule (or "none" if unscheduled).

<Aside type="caution">
Nimbus manages its own cron entries using a unique tag comment. Running `nimbus each` again **replaces** the previous schedule rather than adding a second one — you can't stack multiple schedules.
</Aside>

## How it works under the hood

`nimbus each 6h` translates to a standard cron expression (`0 */6 * * *`) and inserts a line like:

```
0 */6 * * * /usr/bin/python3 /usr/local/bin/nimbus run # NIMBUS-BACKUP-JOB
```

into your user's crontab (`crontab -l`). You can inspect it yourself at any time:

```bash
crontab -l | grep NIMBUS
```
