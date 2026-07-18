import pytest

# parse_cron_expr

@pytest.mark.parametrize("time_str,expected", [
    ("30m", "*/30 * * * *"),
    ("1h", "0 */1 * * *"),
    ("2d", "0 0 */2 * *"),
    ("5H", "0 */5 * * *"),  # case-insensitive
])
def test_parse_cron_expr_valid(nimbus, time_str, expected):
    assert nimbus.parse_cron_expr(time_str) == expected


@pytest.mark.parametrize("bad", ["", "m", "30", "30x", "-5m", "0h", "  "])
def test_parse_cron_expr_invalid(nimbus, bad):
    with pytest.raises(ValueError):
        nimbus.parse_cron_expr(bad)

# would_exclude / make_exclude_filter

def test_would_exclude_matches_dir_anywhere_in_path(nimbus):
    patterns = ["node_modules", "*.log"]
    assert nimbus.would_exclude("project/node_modules/pkg/index.js", patterns)
    assert nimbus.would_exclude("app.log", patterns)
    assert not nimbus.would_exclude("src/main.py", patterns)


def test_make_exclude_filter_drops_matching_tarinfo(nimbus):
    filt = nimbus.make_exclude_filter(["node_modules", "*.log"])

    class FakeTarInfo:
        def __init__(self, name):
            self.name = name

    assert filt(FakeTarInfo("myproj/node_modules/x.js")) is None
    assert filt(FakeTarInfo("myproj/debug.log")) is None
    assert filt(FakeTarInfo("myproj/src/main.py")) is not None

# retentation_targets

def test_retention_targets_keeps_newest_n(nimbus):
    entries = [
        ("a_1", "2024-01-01T00:00:00Z"),
        ("a_2", "2024-01-03T00:00:00Z"),
        ("a_3", "2024-01-02T00:00:00Z"),
    ]
    # keep 2 newest (a_2, a_3) -> delete a_1
    assert nimbus.retention_targets(entries, 2) == ["a_1"]


def test_retention_targets_no_limit_deletes_nothing(nimbus):
    entries = [("a_1", "2024-01-01T00:00:00Z"), ("a_2", "2024-01-02T00:00:00Z")]
    assert nimbus.retention_targets(entries, None) == []
    assert nimbus.retention_targets(entries, 0) == []


def test_retention_targets_keep_more_than_available(nimbus):
    entries = [("a_1", "2024-01-01T00:00:00Z")]
    assert nimbus.retention_targets(entries, 5) == []

#  resolve_exclude_target

def test_resolve_exclude_target_global(nimbus):
    cfg = {"excludes": ["*.tmp"], "directories": []}
    excludes, label = nimbus.resolve_exclude_target(cfg, "global")
    assert label == "global"
    assert excludes is cfg["excludes"]


def test_resolve_exclude_target_untracked_dir_exits(nimbus, tmp_path):
    cfg = {"excludes": [], "directories": []}
    with pytest.raises(SystemExit):
        nimbus.resolve_exclude_target(cfg, str(tmp_path))


def test_resolve_exclude_target_tracked_dir(nimbus, tmp_path):
    path = str(tmp_path.resolve())
    cfg = {"excludes": [], "directories": [{"path": path, "excludes": ["*.bak"]}]}
    excludes, label = nimbus.resolve_exclude_target(cfg, path)
    assert label == path
    assert excludes == ["*.bak"]

# config load/save

def test_load_config_creates_defaults(nimbus, isolated_home):
    cfg = nimbus.load_config()
    assert cfg["directories"] == []
    assert cfg["remote"] is None
    assert cfg["retention"] is None
    assert cfg["encrypt"] is False
    assert nimbus.CONFIG_FILE.exists()


def test_load_config_migrates_old_string_directories(nimbus, isolated_home):
    nimbus.CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    nimbus.CONFIG_FILE.write_text('{"directories": ["/tmp/foo"], "remote": null, "schedule": null, "excludes": []}')
    cfg = nimbus.load_config()
    assert cfg["directories"] == [{"path": "/tmp/foo", "excludes": []}]
    # new keys should have been backfilled
    assert "retention" in cfg
    assert "encrypt" in cfg


def test_cmd_add_and_remove(nimbus, isolated_home, tmp_path):
    target = tmp_path / "mydir"
    target.mkdir()

    class Args:
        directory = str(target)

    nimbus.cmd_add(Args())
    cfg = nimbus.load_config()
    assert nimbus.find_dir_entry(cfg, str(target.resolve())) is not None

    nimbus.cmd_remove(Args())
    cfg = nimbus.load_config()
    assert nimbus.find_dir_entry(cfg, str(target.resolve())) is None


def test_cmd_add_nonexistent_directory_exits(nimbus, isolated_home, tmp_path):
    class Args:
        directory = str(tmp_path / "does-not-exist")

    with pytest.raises(SystemExit):
        nimbus.cmd_add(Args())


def test_dry_run_works_without_rclone_or_remote(nimbus, isolated_home, tmp_path, capsys):
    tracked = tmp_path / "proj"
    tracked.mkdir()
    (tracked / "keep.txt").write_text("hi")
    (tracked / "node_modules").mkdir()
    (tracked / "node_modules" / "pkg.js").write_text("junk")

    cfg = nimbus.load_config()
    cfg["directories"].append({"path": str(tracked.resolve()), "excludes": []})
    cfg["remote"] = None  # deliberately unconfigured
    nimbus.save_config(cfg)

    # Should NOT raise / exit even though rclone isn't installed and no remote is set.
    nimbus.run_backup(cfg, dry_run=True)
    captured = capsys.readouterr()
    assert "would archive" in captured.out
    assert "1" in captured.out  # 1 file included (keep.txt), 1 excluded (node_modules/pkg.j

# log rotation


def test_rotate_log_if_needed_rotates_large_file(nimbus, isolated_home):
    nimbus.CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    nimbus.LOG_FILE.write_bytes(b"x" * (nimbus.LOG_MAX_BYTES + 1))
    nimbus.rotate_log_if_needed()
    assert not nimbus.LOG_FILE.exists()
    assert nimbus.LOG_FILE.with_name("nimbus.log.1").exists()


def test_rotate_log_if_needed_leaves_small_file(nimbus, isolated_home):
    nimbus.CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    nimbus.LOG_FILE.write_text("small log")
    nimbus.rotate_log_if_needed()
    assert nimbus.LOG_FILE.exists()
    assert nimbus.LOG_FILE.read_text() == "small log"
