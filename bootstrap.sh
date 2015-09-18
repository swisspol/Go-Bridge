#!/bin/sh -ex

source "env.sh"

# Download source
if [ ! -f "go$GO_VERSION.darwin-amd64.tar.gz" ]
then
  curl -O "https://storage.googleapis.com/golang/go$GO_VERSION.darwin-amd64.tar.gz"
fi

# Extract source
rm -rf "$GOROOT"
rm -rf "go"
tar -xvf "go$GO_VERSION.darwin-amd64.tar.gz"
mv "go" "$GOROOT"

# Build for MacOSX / x86_64
(
  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=amd64
  export CGO_CFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/MacOSX_x86_64" -v -x std
)

# Build for iPhoneSimulator / i386
(
  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=386
  export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_i386" -tags=ios -v -x std
)

# Build for iPhoneSimulator / x86_64
(
  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=amd64
  export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_x86_64" -tags=ios -v -x std
)

# Build for iPhoneOS / armv7
(
  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=arm
  export GOARM=7
  export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneOS_armv7" -tags=ios -v -x std
)

# Build for iPhoneOS / arm64
(
  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=arm64
  export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneOS_arm64" -tags=ios -v -x std
)
