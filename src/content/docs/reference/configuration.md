---
title: Configuration File
description: Where Nimbus stores its settings and what the format looks like.
---

Nimbus stores everything in a single JSON file — no databases, no hidden state.

## File locations

| Path | Purpose |
|---|---|
| `~/.config/nimbus/config.json` | Configuration (tracked directories, remote, schedule, excludes) |
| `~/.config/nimbus/nimbus.log` | Activity log (append-only) |
| `~/.local/share/nimbus/staging/` | Temporary archives during a backup run (auto-cleaned) |

## `config.json` structure

```json
{
  "directories": [
    {
      "path": "/home/user/Documents",
      "excludes": []
    },
    {
      "path": "/home/user/projects/app1",
      "excludes": ["node_modules", "dist"]
    }
  ],
  "remote": "gdrive:Backups",
  "schedule": "6h",
  "excludes": ["node_modules", ".git", "__pycache__", "*.log", ".DS_Store"],
  "retention": 5,
  "encrypt": false
}
```

| Field | Type | Description |
|---|---|---|
| `directories` | array | Tracked directories, each with its own `excludes` list |
| `remote` | string \| null | The rclone remote + folder, e.g. `gdrive:Backups` |
| `schedule` | string \| null | Current cron interval (`30m`, `6h`, `1d`), or `null` if unscheduled |
| `excludes` | array | Global exclude patterns applied to every directory |
| `retention` | number \| null | Keep only the N newest backups per directory on the remote; `null` means unlimited. See [Retention](/nimbus/guides/retention/) |
| `encrypt` | boolean | Whether archives are GPG-encrypted before upload. See [Encryption](/nimbus/guides/encryption/) |

## Editing manually

You can edit `config.json` directly with a text editor if you prefer — Nimbus reads it fresh on every command. Just make sure it stays valid JSON.

## Automatic migration

Older versions of Nimbus stored `directories` as a plain list of path strings. If Nimbus detects this old format, it automatically converts it to the current `{path, excludes}` structure the first time you run any command — no manual action needed.

Upgrading from a config file created before `retention` and `encrypt` existed works the same way: any missing keys are backfilled with their defaults (`null` and `false` respectively) the first time you run any command.
