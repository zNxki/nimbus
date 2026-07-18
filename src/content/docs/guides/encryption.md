---
title: Encrypting Backups
description: Encrypt archives with GPG/AES256 before they leave your machine.
---

import { Aside } from '@astrojs/starlight/components';

By default, archives are uploaded to Google Drive as plain `.tar.gz` files — protected in transit
by HTTPS, but readable by anyone with access to the Drive folder. Nimbus can optionally encrypt
each archive locally with GPG before it ever leaves your machine.

## Enable encryption

```bash
nimbus set ENCRYPTION on
```

This requires `gpg` to be installed. If it isn't, Nimbus tells you how to install it
(`sudo apt install gnupg`, or the equivalent for your distro) and stops.

Turning it on also prints a reminder to set a passphrase — see the next step.

## Set the passphrase

Encryption is symmetric (AES256), keyed by a passphrase you provide via an environment variable:

```bash
export NIMBUS_PASSPHRASE='your-secret-passphrase'
```

<Aside type="caution">
There is no recovery if you lose this passphrase — Nimbus doesn't store it anywhere. Keep a copy
somewhere safe outside of Nimbus (a password manager, for example).
</Aside>

`NIMBUS_PASSPHRASE` needs to be set in the environment whenever a backup actually runs — including
scheduled runs via `cron`. If you use `nimbus each`, make sure the passphrase is exported wherever
cron picks up its environment (e.g. in the crontab itself, or a file cron sources), otherwise each
scheduled run will fail with "NIMBUS_PASSPHRASE is not set".

## Run a backup

```bash
nimbus run
```

With encryption on, each archive is compressed as usual and then immediately encrypted with:

```bash
gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 --symmetric --cipher-algo AES256 -o <archive>.tar.gz.gpg <archive>.tar.gz
```

The plaintext `.tar.gz` is deleted right after encryption succeeds — only the `.gpg` file is
uploaded. If `NIMBUS_PASSPHRASE` isn't set, or encryption fails for any reason, that directory's
archive is skipped (logged as an error) and the run continues with the next tracked directory.

## Disable encryption

```bash
nimbus set ENCRYPTION off
```

Existing `.gpg` archives already on Drive aren't affected — only future runs go back to plain
`.tar.gz`.

## Restoring an encrypted backup

See [Restoring Backups](/nimbus/guides/restoring/#encrypted-backups) — `nimbus restore` downloads
the `.gpg` file as-is, and you decrypt it locally with the same passphrase.
