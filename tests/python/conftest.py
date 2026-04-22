from pathlib import Path
import sys

# Allow direct import of scripts from bin/
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent / "bin"))
