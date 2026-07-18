---
title: Installation
description: How to install Nimbus on Ubuntu, Arch, or Fedora.
---

import { Tabs, TabItem } from '@astrojs/starlight/components';
import { Aside } from '@astrojs/starlight/components';

Nimbus ships as a single Python script plus a Bash installer. It works on any Linux distribution using `apt`, `pacman`, or `dnf`.

## One-liner install (recommended)

<Tabs>
<TabItem label="curl | bash">
```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash
```
</TabItem>
<TabItem label="Process substitution">
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh)
```
</TabItem>
</Tabs>

<Aside type="tip">
If interactive prompts don't behave well over a pipe on your shell, prefer the process-substitution form (`bash <(curl ...)`) — it keeps your keyboard input attached to the script.
</Aside>

Running the installer with no arguments shows an interactive menu:

```
[1] INSTALL
[2] UPDATE
[3] UNINSTALL

Choice:
```

Pick `1` for a fresh install.

## From a local clone

```bash
git clone https://github.com/zNxki/nimbus.git
cd nimbus
chmod +x nimbus install.sh
./install.sh install
```

## What the installer does

1. **Detects your package manager** — `apt` (Ubuntu/Debian), `pacman` (Arch), or `dnf` (Fedora/RHEL)
2. **Installs dependencies** — `rclone` and `python3`, if not already present
3. **Installs `gnupg`** (best-effort) — only needed later if you turn on [archive encryption](/nimbus/guides/encryption/); installation continues even if this step fails
4. **Copies the script** to `/usr/local/bin/nimbus`, making it available system-wide

## Verify the install

```bash
nimbus --version
nimbus --help
```

If you see the version number and the list of commands, you're good to go — next, [connect Google Drive](/nimbus/getting-started/rclone-setup/).

## Non-interactive usage

You can skip the menu entirely by passing the action directly — handy for scripts and automation:

```bash
./install.sh install
./install.sh update
./install.sh uninstall
```

Via curl, pass the action after `-s --`:

```bash
curl -fsSL https://raw.githubusercontent.com/zNxki/nimbus/main/install.sh | bash -s -- update
```
