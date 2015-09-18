Overview
========

This sample Xcode project demonstrates how to build and call Go code from OS X / iPhone / Simulator executables.

Getting Started
===============

1. Clone repo and `cd` into the directory
2. Run `./bootstrap.sh`

Limitations
===========

- Building Go code for iPhone does not include bitcode
- Building Go code for iOS Simulator on i386 does not work (see below)

```
/Users/pol/Downloads/Tests/go-1.5.1/pkg/tool/darwin_amd64/link -o $WORK/command-line-arguments/_obj/exe/a.out.a -L $WORK -L /Users/pol/Downloads/Tests/go-1.5.1/pkg_cross/iPhoneSimulator_i386 -extld=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -buildmode=c-archive -buildid=a5117489b1092eae5e08f28729578dbb1167953c $WORK/command-line-arguments.a
# command-line-arguments
_rt0_386_darwin_lib.ptr: _rt0_386_darwin_lib: not defined
_rt0_386_darwin_lib.ptr: undefined: _rt0_386_darwin_lib
```
