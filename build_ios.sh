#!/bin/bash

base_dir=$(cd "`dirname "0"`" && pwd)
build_dir=$base_dir/build
lib_dir=$base_dir/lib/ios

if [ ! -d "$build_dir" ]; then
  mkdir -p $build_dir
fi

if [ ! -d "$lib_dir" ]; then
  mkdir -p $lib_dir
fi

echo -e "--------------------------------------------------------"
echo -e "-- Compiling SwiftMessages library (and dependencies) --"
echo -e "--------------------------------------------------------\n"
xcodebuild -target "SwiftMessages" -configuration Release -arch arm64 only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "SwiftMessages" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
echo -e "Success\n"

echo -e "-------------------------------------------------"
echo -e "-- Creating SwiftMessages.framework FAT binary --"
echo -e "-------------------------------------------------\n"
cd build
cp -R $build_dir/Release-iphoneos/SwiftMessages.framework $lib_dir
lipo -create -output $lib_dir/SwiftMessages.framework/SwiftMessages $build_dir/Release-iphoneos/SwiftMessages.framework/SwiftMessages $build_dir/Release-iphonesimulator/SwiftMessages.framework/SwiftMessages
cp -R $build_dir/Release-iphonesimulator/SwiftMessages.framework/Modules/SwiftMessages.swiftmodule/* $lib_dir/SwiftMessages.framework/Modules/SwiftMessages.swiftmodule/
echo -e "Success: \n" $lib_dir/SwiftMessages.framework "\n"

echo -e "---------------------------------------------------"
echo -e "-- Validating SwiftMessages.framework FAT binary --"
echo -e "---------------------------------------------------\n"
lipo -info $lib_dir/SwiftMessages.framework/SwiftMessages
echo -e ""
