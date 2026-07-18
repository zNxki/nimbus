---
title: Excluding Files & Folders
description: Skip node_modules, .git, and other noise — globally or per directory.
---

import { Aside } from '@astrojs/starlight/components';

Not everything in a folder needs to be backed up. Nimbus supports two levels of exclusion rules.

## Global excludes

Applied to **every** tracked directory. By default, Nimbus ships with:

```
node_modules
.git
__pycache__
*.log
.DS_Store
```

Add your own:

```bash
nimbus exclude add global "*.tmp"
nimbus exclude add global dist
```

## Per-directory excludes

Applied only to one specific tracked directory — useful when one project needs `node_modules` ignored and another doesn't:

```bash
nimbus add ~/projects/app1
nimbus add ~/projects/app2

nimbus exclude add ~/projects/app1 node_modules
```

Now `node_modules` is skipped only inside `app1`; `app2` still backs it up in full.

<Aside type="note">
Per-directory rules **stack on top of** global rules — they don't replace them.
</Aside>

## Removing an exclude rule

```bash
nimbus exclude remove global "*.tmp"
nimbus exclude remove ~/projects/app1 node_modules
```

## Viewing current rules

```bash
nimbus exclude list
```

Shows global excludes first, then each tracked directory with its own rules.

## Pattern matching

Patterns use glob-style matching (`fnmatch`) and are checked against:

- The **filename** or **folder name** itself
- Any **path component** inside the tracked directory

So excluding `node_modules` skips it no matter how deeply nested it is (`app/packages/foo/node_modules`, `app/node_modules`, etc.).

Examples of valid patterns:

| Pattern | Matches |
|---|---|
| `node_modules` | Any folder named exactly `node_modules` |
| `*.log` | Any file ending in `.log` |
| `.git` | The `.git` folder |
| `build` | Any folder or file named `build` |
