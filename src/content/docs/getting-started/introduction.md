---
title: Introduction
description: What Nimbus is and why it exists.
---

**Nimbus** is a lightweight command-line tool for Linux that backs up any folder to **Google Drive**, on demand or on a schedule.

It doesn't reinvent the wheel for cloud storage — under the hood, Nimbus uses [rclone](https://rclone.org/), the industry-standard tool for talking to cloud providers. Nimbus just wraps it in a friendly, opinionated CLI focused on one job: **backing up folders reliably, without fuss**.

## What Nimbus does

- Compresses tracked directories into timestamped `.tar.gz` archives
- Uploads them to a Google Drive folder of your choice via `rclone`, and verifies each upload's size against the remote afterwards
- Optionally encrypts archives with GPG/AES256 before they ever leave your machine
- Optionally prunes old backups automatically, keeping only the N newest per directory ([retention](/nimbus/guides/retention/))
- Lets you exclude noisy files/folders (globally or per directory) — e.g. `node_modules`, `.git`, build artifacts
- Runs on a schedule via `cron`, or on demand — with a `--dry-run` mode to preview a run first
- Can also mirror a directory incrementally straight to the remote via `nimbus sync`, instead of a full archive each time
- Lets you list and download previous backups with `nimbus restore`
- Logs every run so you always know what happened and when

## What Nimbus is *not*

- Not a general-purpose sync tool for every use case — `nimbus sync` covers the common incremental case, but for anything more advanced use `rclone sync` directly
- Not a versioned backup system with deduplication (each `nimbus run` creates a new archive; use [retention](/nimbus/guides/retention/) to cap how many are kept)
- Not tied to Google Drive forever — since it's built on rclone, other providers are on the [roadmap](https://github.com/zNxki/nimbus#️-roadmap)

## How it's built

- A single Python 3 script (`nimbus`) — no heavy dependencies, no virtualenv required
- A Bash installer (`install.sh`) that detects your package manager (`apt`, `pacman`, `dnf`) and sets everything up
- Configuration lives in a plain JSON file at `~/.config/nimbus/config.json`

Ready to install it? Head to the [Installation](/nimbus/getting-started/installation/) page.
