#!/bin/bash

cp -a YandexMapKit YandexMapKit_sim
mv YandexMapKit YandexMapKit_device

cd YandexMapKit_sim/YandexMapKit.framework/Versions/A
lipo -thin x86_64 YandexMapKit -output YandexMapKit_x86_64
lipo -thin i386 YandexMapKit -output YandexMapKit_i386
lipo -create YandexMapKit_x86_64 YandexMapKit_i386 -output YandexMapKit_sim
rm -rf YandexMapKit YandexMapKit_x86_64 YandexMapKit_i386
mv YandexMapKit_sim YandexMapKit
cd ../../../..

cd YandexMapKit_device/YandexMapKit.framework/Versions/A
lipo -thin armv7 YandexMapKit -output YandexMapKit_armv7
lipo -thin arm64 YandexMapKit -output YandexMapKit_arm64
lipo -create YandexMapKit_armv7 YandexMapKit_arm64 -output YandexMapKit_device
rm -rf YandexMapKit YandexMapKit_armv7 YandexMapKit_arm64
mv YandexMapKit_device YandexMapKit
cd ../../../..

xcodebuild -create-xcframework -framework YandexMapKit_sim/YandexMapKit.framework -framework YandexMapKit_device/YandexMapKit.framework -output YandexMapKit.xcframework
rm -rf YandexMapKit_sim YandexMapKit_device

cp -a YandexRuntime YandexRuntime_sim
mv YandexRuntime YandexRuntime_device

cd YandexRuntime_sim/YandexRuntime.framework/Versions/A
lipo -thin x86_64 YandexRuntime -output YandexRuntime_x86_64
lipo -thin i386 YandexRuntime -output YandexRuntime_i386
lipo -create YandexRuntime_x86_64 YandexRuntime_i386 -output YandexRuntime_sim
rm -rf YandexRuntime YandexRuntime_x86_64 YandexRuntime_i386
mv YandexRuntime_sim YandexRuntime
cd ../../../..

cd YandexRuntime_device/YandexRuntime.framework/Versions/A
lipo -thin armv7 YandexRuntime -output YandexRuntime_armv7
lipo -thin arm64 YandexRuntime -output YandexRuntime_arm64
lipo -create YandexRuntime_armv7 YandexRuntime_arm64 -output YandexRuntime_device
rm -rf YandexRuntime YandexRuntime_armv7 YandexRuntime_arm64
mv YandexRuntime_device YandexRuntime
cd ../../../..

xcodebuild -create-xcframework -framework YandexRuntime_sim/YandexRuntime.framework -framework YandexRuntime_device/YandexRuntime.framework -output YandexRuntime.xcframework
rm -rf YandexRuntime_sim YandexRuntime_device

