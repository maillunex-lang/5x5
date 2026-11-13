#!/usr/bin/env python3
"""Run source regression tests from any working directory."""
from pathlib import Path
import subprocess
import sys
root = Path(__file__).resolve().parents[1]
raise SystemExit(subprocess.call([sys.executable, "-m", "unittest", "discover", "-s", str(root / "tests"), "-q"], cwd=root))