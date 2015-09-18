#!/bin/sh -ex

source "env.sh"

BUILD_DIR="`pwd`/build/$PLATFORM_NAME"
mkdir -p "$BUILD_DIR"

if [ "$PLATFORM_NAME" == "macosx" ]
then
  (
    export CGO_ENABLED=1
    export GOOS=darwin
    export GOARCH=amd64
    export CGO_CFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
    export CGO_LDFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
    go build -pkgdir="$GOROOT/pkg_cross/MacOSX_x86_64" -v -x -buildmode=c-archive -o "$BUILD_DIR/main.a" "go/main.go"
  )
elif [ "$PLATFORM_NAME" == "iphonesimulator" ]
then
  # (
  #   export CGO_ENABLED=1
  #   export GOOS=darwin
  #   export GOARCH=386
  #   export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  #   export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  #   go build -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_i386" -tags=ios -v -x -buildmode=c-archive -o "$BUILD_DIR/main_32.a" "go/main.go"
  # )
  (
    export CGO_ENABLED=1
    export GOOS=darwin
    export GOARCH=amd64
    export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
    export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
    go build -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_x86_64" -tags=ios -v -x -buildmode=c-archive -o "$BUILD_DIR/main_64.a" "go/main.go"
  )
  
  # TODO: Building for iOS Simulator on i386 does not work
  mv -f "$BUILD_DIR/main_64.h" "$BUILD_DIR/main.h"
  mv -f "$BUILD_DIR/main_64.a" "$BUILD_DIR/main.a"
  
  # printf "#ifdef __LP64__\n#include \"main_64.h\"\n#else\n#include \"main_32.h\"\n#endif\n" > "$BUILD_DIR/main.h"
  #
  # $LIPO -create "$BUILD_DIR/main_32.a" "$BUILD_DIR/main_64.a" -output "$BUILD_DIR/main.a"
  # rm "$BUILD_DIR/main_32.a" "$BUILD_DIR/main_64.a"
elif [ "$PLATFORM_NAME" == "iphoneos" ]
then
  (
    export CGO_ENABLED=1
    export GOOS=darwin
    export GOARCH=arm
    export GOARM=7
    export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
    export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
    go build -pkgdir="$GOROOT/pkg_cross/iPhoneOS_armv7" -tags=ios -v -x -buildmode=c-archive -o "$BUILD_DIR/main_32.a" "go/main.go"
  )
  (
    export CGO_ENABLED=1
    export GOOS=darwin
    export GOARCH=arm64
    export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
    export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
    go build -pkgdir="$GOROOT/pkg_cross/iPhoneOS_arm64" -tags=ios -v -x -buildmode=c-archive -o "$BUILD_DIR/main_64.a" "go/main.go"
  )
  
  printf "#ifdef __LP64__\n#include \"main_64.h\"\n#else\n#include \"main_32.h\"\n#endif\n" > "$BUILD_DIR/main.h"
  
  $LIPO -create "$BUILD_DIR/main_32.a" "$BUILD_DIR/main_64.a" -output "$BUILD_DIR/main.a"
  rm "$BUILD_DIR/main_32.a" "$BUILD_DIR/main_64.a"
fi
