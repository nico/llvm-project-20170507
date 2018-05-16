Goals:
- Run no python code at gn gen time, for speed
- Source files are listed right in the gn files; use
  `gn/sync_source_lists_from_cmake.py` to keep the in sync after pulling

Missing:
- monorepro "projects to build" selection mechanism
- actual compiler flags (dead code stripping, warnings, etc)
- optimized tablegen in debug builds (having an `add_tablegen` template might
  make sense now that there's llvm-tblgen and clang-tblgen)
- describe how to get or build a gn binary
- Probably want small feature headers for the feature config toggles, and
  per-platform defaults instead of configure for things like headers to use.
  (e.g. `llvm_have_xar` only used by llvm-objdump?)
- cross build
- bootstrap build
- a better place to put the main gn config; new folder in monorepro isn't great
- maybe a plan for non-monorepos?
