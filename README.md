Goals:
- Run no python code at gn gen time, for speed
- Source files are listed right in the gn files; use
  `gn/sync_source_lists_from_cmake.py` to keep the in sync after pulling

Missing:
- give clang and lld correct --version output (currently dummy values in
  lld/Common/BUILD.gn and clang/lib/Basic/BUILD.gn)
- hook up lit / tests
  - llvm-config
- lib/Headers for clang
- monorepro "projects to build" selection mechanism
- actual compiler flags, debug/release, asserts on/off, ...
- optimized tablegen in debug builds (having an `add_tablegen` template might
  make sense now that there's llvm-tblgen and clang-tblgen)
- make tablegen() write nothing if the output didn't change
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
