#!/bin/sh -ex

GO_VERSION="1.5.1"

OSX_MIN_VERSION="10.8"
IOS_MIN_VERSION="8.0"

DEVELOPER_DIR=`xcode-select --print-path`

MACOSX_SDK_VERSION=`xcodebuild -version -sdk | grep -A 1 '^MacOSX' | tail -n 1 |  awk '{ print $2 }'`
MACOSX_SDK_PATH="$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$MACOSX_SDK_VERSION.sdk"

IPHONEOS_SDK_VERSION=`xcodebuild -version -sdk | grep -A 1 '^iPhoneOS' | tail -n 1 |  awk '{ print $2 }'`
IPHONEOS_SDK_PATH="$DEVELOPER_DIR/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$IPHONEOS_SDK_VERSION.sdk"

IPHONESIMULATOR_SDK_VERSION=`xcodebuild -version -sdk | grep -A 1 '^iPhoneSimulator' | tail -n 1 |  awk '{ print $2 }'`
IPHONESIMULATOR_SDK_PATH="$DEVELOPER_DIR/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$IPHONESIMULATOR_SDK_VERSION.sdk"


export GOROOT="`pwd`/go-$GO_VERSION"
export GOPATH="`pwd`/go"

export PATH="$PATH:$GOROOT/bin"
