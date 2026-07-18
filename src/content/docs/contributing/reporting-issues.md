---
title: Reporting Issues
description: How to file a good bug report or feature request for Nimbus.
---

Open issues at **[github.com/zNxki/nimbus/issues](https://github.com/zNxki/nimbus/issues)**. A good issue gets fixed faster — here's what to include.

## 🐛 Bug report template

```markdown
**Describe the bug**
A clear description of what went wrong.

**To Reproduce**
1. Ran `nimbus ...`
2. ...

**Expected behavior**
What you expected to happen instead.

**Environment**
- OS/Distro: (e.g. Ubuntu 26.04, Arch, Fedora 41)
- Nimbus version: `nimbus --version`
- Installed via: curl one-liner / local clone

**Logs**
```
paste relevant output from `nimbus log --lines 30` here
```

**Additional context**
Anything else — VPS vs desktop, custom cron setup, etc.
```

## ✨ Feature request template

```markdown
**Is your feature request related to a problem?**
e.g. "I always have to manually delete old backups because..."

**Describe the solution you'd like**
What command or behavior would solve it.

**Describe alternatives you've considered**
Any workarounds you're currently using.

**Additional context**
Links, examples from other tools, etc.
```

## Known roadmap items

Before opening a feature request, check if it's already tracked:

- [ ] Backup rotation / retention policy
- [ ] Optional archive encryption before upload
- [ ] Support for additional cloud providers (S3, Dropbox, OneDrive)
- [ ] Locking to prevent overlapping backup runs

If your request matches one of these, feel free to +1 the existing issue instead of opening a duplicate.

## Security issues

If you find a security-related issue (e.g. something involving how credentials or tokens are handled), please **do not** open a public issue — instead use GitHub's private vulnerability reporting (`Security` tab → `Report a vulnerability`) on the repo.
