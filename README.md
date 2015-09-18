Overview
========

This sample Xcode project demonstrates how to build and call Go code from OS X / iPhone / iOS Simulator executables.

Getting Started
===============

1. Clone repo and `cd` into the directory
2. Run `./bootstrap.sh`

Limitations
===========

1) Go code is built with absolute addressing which triggers a warning when linking the executable

```
(null): PIE disabled. Absolute addressing (perhaps -mdynamic-no-pic) not allowed in code signed PIE, but used in __cgoexp_45a75e65c81e_Test from build/iphoneos/main.a(go.o). To fix this warning, don't compile with -mdynamic-no-pic or link with -Wl,-no_pie
```

2) Go code is not built with bitcode when building for iPhone

3) Go code fails to build for iOS Simulator on i386 (the Xcode project is therefore configured to only use it in 64 bit mode)

```
/Users/pol/Downloads/Tests/go-1.5.1/pkg/tool/darwin_amd64/link -o $WORK/command-line-arguments/_obj/exe/a.out.a -L $WORK -L /Users/pol/Downloads/Tests/go-1.5.1/pkg_cross/iPhoneSimulator_i386 -extld=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -buildmode=c-archive -buildid=a5117489b1092eae5e08f28729578dbb1167953c $WORK/command-line-arguments.a
# command-line-arguments
_rt0_386_darwin_lib.ptr: _rt0_386_darwin_lib: not defined
_rt0_386_darwin_lib.ptr: undefined: _rt0_386_darwin_lib
```
