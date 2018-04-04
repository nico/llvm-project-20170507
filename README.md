Missing:
- mechanism to configure archs to include in lib/Target build
- hook up lit / tests
- monorepro "projects to build" selection mechanism
- actual compiler flags, debug/release, asserts on/off, ...
- optimized tablegen in debug builds
- make tablegen() write nothing if the output didn't change
- describe how to get or build a gn binary
- configure step equivalent. For now,
  `cp /path/to/cmake/build/llvm/include/Config/{AsmParsers.def,AsmPrinters.def,Disassemblers.def,Targets.def,abi-breaking.h,config.h,llvm-config.h} llvm/include/llvm/Config`.
  For now, the `declare_args` need to match the copied-over config files.
  Probably want small feature headers for the feature config toggles, and
  per-platform defaults instead of configure for things like headers to use.
- cross build
- bootstrap build
- a better place to put the main gn config; new folder in monorepro isn't great
- maybe a plan for non-monorepos?
