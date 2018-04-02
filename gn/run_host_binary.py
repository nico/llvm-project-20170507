"""Runs a native LLVM host binary."""

import subprocess
import sys

# Prefix with ./ to run built binary, not arbitrary stuff from PATH.
sys.exit(subprocess.call(['./' + sys.argv[1]] + sys.argv[2:]))
