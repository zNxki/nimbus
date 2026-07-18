---
title: Updating & Uninstalling
description: Keeping Nimbus up to date, or removing it cleanly.
---

import { Aside } from '@astrojs/starlight/components';

Both actions go through the same `install.sh` script you used to install Nimbus.

## Interactive menu

Run the installer with no arguments to get a menu:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh)
```

```
[1] INSTALL
[2] UPDATE
[3] UNINSTALL

Choice:
```

## Updating

```bash
./install.sh update
```

Nimbus checks the version installed locally (`nimbus --version`) against the latest version published on GitHub. If they match, it tells you you're already up to date and does nothing. If a newer version is available, it downloads and replaces the binary.

<Aside type="tip">
Your configuration (`~/.config/nimbus/config.json`), logs, and scheduled cron job are **never touched** by an update.
</Aside>

## Uninstalling

```bash
./install.sh uninstall
```

This will:

1. Ask you to confirm removing the `nimbus` command
2. Remove `/usr/local/bin/nimbus`
3. Automatically remove any Nimbus cron job (`nimbus each` schedules)
4. Ask **separately** whether to also delete your configuration, logs, and staging data (`~/.config/nimbus`, `~/.local/share/nimbus`)

Answering "no" to the last prompt keeps your tracked directories, remote, and exclude rules intact — handy if you're planning to reinstall later.

## Non-interactive usage

Both actions can be triggered directly, without the menu — useful in scripts:

```bash
./install.sh update
./install.sh uninstall
```

Or via curl:

```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash -s -- update
```
