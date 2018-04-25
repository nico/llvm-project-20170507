Goals:
- Run no python code at gn gen time, for speed
- Source files are listed right in the gn files; use
  `gn/sync_source_lists_from_cmake.py` to keep the in sync after pulling

Missing:
- omit check-lld, check-clang from default target
  (see gn help on `ninja_rules`, `execution`)
- hook up check-llvm
- monorepro "projects to build" selection mechanism
- actual compiler flags (dead code stripping etc)
- optimized tablegen in debug builds (having an `add_tablegen` template might
  make sense now that there's llvm-tblgen and clang-tblgen)
- describe how to get or build a gn binary
- configure step equivalent. For now,
  `cp /path/to/cmake/build/llvm/include/Config/{abi-breaking.h,config.h,llvm-config.h} llvm/include/llvm/Config`.
  `cp /path/to/cmake/build/tools/clang/include/clang/Config/config.h clang/include/clang/Config`.
  For now, the `declare_args` need to match the copied-over config files.
  Probably want small feature headers for the feature config toggles, and
  per-platform defaults instead of configure for things like headers to use.
- cross build
- bootstrap build
- a better place to put the main gn config; new folder in monorepro isn't great
- maybe a plan for non-monorepos?
