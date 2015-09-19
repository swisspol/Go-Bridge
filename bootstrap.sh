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
  export CC=`xcrun -find clang`
  export CXX=`xcrun -find clang++`

  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=amd64
  export CGO_CFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $MACOSX_SDK_PATH -arch x86_64 -mmacosx-version-min=$OSX_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/MacOSX_x86_64" -tags="" -v -x std
)

# Build for iPhoneSimulator / i386
(
  export CC=`xcrun -find clang`
  export CXX=`xcrun -find clang++`

  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=386
  export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch i386 -mios-simulator-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_i386" -tags="ios" -v -x std
)

# Build for iPhoneSimulator / x86_64
(
  export CC=`xcrun -find clang`
  export CXX=`xcrun -find clang++`

  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=amd64
  export CGO_CFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONESIMULATOR_SDK_PATH -arch x86_64 -mios-simulator-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneSimulator_x86_64" -tags="ios" -v -x std
)

# Build for iPhoneOS / armv7
(
  export CC=`xcrun -find clang`
  export CXX=`xcrun -find clang++`

  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=arm
  export GOARM=7
  export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch armv7 -miphoneos-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneOS_armv7" -tags="ios" -v -x std
)

# Build for iPhoneOS / arm64
(
  export CC=`xcrun -find clang`
  export CXX=`xcrun -find clang++`

  export CGO_ENABLED=1
  export GOOS=darwin
  export GOARCH=arm64
  export CGO_CFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
  export CGO_LDFLAGS="-isysroot $IPHONEOS_SDK_PATH -arch arm64 -miphoneos-version-min=$IOS_MIN_VERSION"
  go install -pkgdir="$GOROOT/pkg_cross/iPhoneOS_arm64" -tags="ios" -v -x std
)

# Download NDK
if [ ! -f "gomobile-ndk-$ANDROID_NDK_VERSION-darwin-x86_64.tar.gz" ]
then
  curl -O "https://dl.google.com/go/mobile/gomobile-ndk-$ANDROID_NDK_VERSION-darwin-x86_64.tar.gz"
fi

# Extract NDK
rm -rf "$ANDROID_NDK_PATH"
rm -rf "android-ndk-r10e"
tar -xvf "gomobile-ndk-$ANDROID_NDK_VERSION-darwin-x86_64.tar.gz"
mv "android-ndk-r10e" "$ANDROID_NDK_PATH"

# Patch NDK
mkdir -p "$ANDROID_NDK_PATH/arm/sysroot/usr"
mv "$ANDROID_NDK_PATH/platforms/android-15/arch-arm/usr/include" "$ANDROID_NDK_PATH/arm/sysroot/usr/include"
mv "$ANDROID_NDK_PATH/platforms/android-15/arch-arm/usr/lib" "$ANDROID_NDK_PATH/arm/sysroot/usr/lib"
mv "$ANDROID_NDK_PATH/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64/bin" "$ANDROID_NDK_PATH/arm/bin"
mv "$ANDROID_NDK_PATH/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64/lib" "$ANDROID_NDK_PATH/arm/lib"
mv "$ANDROID_NDK_PATH/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64/libexec" "$ANDROID_NDK_PATH/arm/libexec"
mkdir -p "$ANDROID_NDK_PATH/arm/arm-linux-androideabi/bin"
ln -s "$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-ld" "$ANDROID_NDK_PATH/arm/arm-linux-androideabi/bin/ld"
ln -s "$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-as" "$ANDROID_NDK_PATH/arm/arm-linux-androideabi/bin/as"
ln -s "$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-gcc" "$ANDROID_NDK_PATH/arm/arm-linux-androideabi/bin/gcc"
ln -s "$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-g++" "$ANDROID_NDK_PATH/arm/arm-linux-androideabi/bin/g++"

# Build for Android / armv7
(
  export CC="$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-gcc"
  export CXX="$ANDROID_NDK_PATH/arm/bin/arm-linux-androideabi-g++"
  
  export CGO_ENABLED=1
  export GOOS=android
  export GOARCH=arm
  export GOARM=7
  go install -pkgdir="$GOROOT/pkg_cross/Android_armv7" -tags="" -v -x std
)
