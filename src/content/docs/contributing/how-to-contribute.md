---
title: How to Contribute
description: Guidelines for contributing to Nimbus.
---

Nimbus is a small, focused project — contributions of any size are welcome, from typo fixes in this documentation to new features.

## Project structure

```
nimbus/
├── nimbus              # main executable (Python 3, single file)
├── install.sh           # installer (Bash): install / update / uninstall
├── tests/               # pytest suite for the pure/helper functions in `nimbus`
│   ├── conftest.py
│   └── test_nimbus.py
├── .github/workflows/   # CI pipeline (GitHub Actions)
└── README.md            # project overview
```

## Setting up a dev environment

```bash
git clone https://github.com/zNxki/nimbus.git
cd nimbus
chmod +x nimbus install.sh
python3 -m py_compile nimbus   # quick syntax check
pip install pytest
pytest                          # run the test suite
```

No external Python dependencies for `nimbus` itself — the standard library is enough. `pytest` is
only needed for running the test suite. `rclone` (and `gpg`, if touching encryption) need to be
installed separately for end-to-end testing.

## Making changes

1. Fork the repo and create a branch: `git checkout -b feature/my-change`
2. Keep changes focused — one feature or fix per pull request
3. Test:
   - `pytest` — the existing suite covers helpers like `parse_cron_expr`, `would_exclude`, `retention_targets`, and config migration
   - Add tests for any new pure/helper function you introduce
   - `python3 -m py_compile nimbus` for syntax
   - `bash -n install.sh` for the installer's syntax
   - Run through the affected commands against a throwaway `HOME` directory, e.g.:
     ```bash
     export HOME=/tmp/nimbus-test
     mkdir -p "$HOME"
     python3 nimbus add /tmp/some-folder
     python3 nimbus list
     ```
4. Update the relevant docs page(s) if behavior changes
5. Open a pull request describing **what** changed and **why** — CI will automatically run the test suite against your PR

## Code style

- Python: stick to the standard library, keep functions small and single-purpose, match the existing logging style (`log()`, `ok()`, `warn()`, `err()`)
- Bash: `set -e`, quote your variables, keep the color/banner style consistent

## Reporting bugs or requesting features

See [Reporting Issues](/nimbus/contributing/reporting-issues/) for the template to use.
