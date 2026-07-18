import importlib.util
import sys
from importlib.machinery import SourceFileLoader
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SCRIPT_PATH = REPO_ROOT / "nimbus"

def _load_nimbus_module():
    loader = SourceFileLoader("nimbus_cli", str(SCRIPT_PATH))
    spec = importlib.util.spec_from_loader("nimbus_cli", loader)
    module = importlib.util.module_from_spec(spec)
    sys.modules["nimbus_cli"] = module
    loader.exec_module(module)
    return module


@pytest.fixture(scope="session")
def nimbus():
    """The nimbus CLI script, loaded as an importable module."""
    return _load_nimbus_module()


@pytest.fixture
def isolated_home(tmp_path, monkeypatch, nimbus):
    """Points nimbus's config/log/staging paths at a throwaway tmp_path for this test."""
    config_dir = tmp_path / ".config" / "nimbus"
    monkeypatch.setattr(nimbus, "CONFIG_DIR", config_dir)
    monkeypatch.setattr(nimbus, "CONFIG_FILE", config_dir / "config.json")
    monkeypatch.setattr(nimbus, "LOG_FILE", config_dir / "nimbus.log")
    monkeypatch.setattr(nimbus, "STAGING_DIR", tmp_path / ".local" / "share" / "nimbus" / "staging")
    return tmp_path
