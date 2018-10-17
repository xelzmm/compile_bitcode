#!/bin/bash

rm -rf *.o *.a *.dylib

SDK_IPHONEOS=`xcrun --show-sdk-path --sdk iphoneos`
SDK_IPHONESIMULATOR=`xcrun --show-sdk-path --sdk iphonesimulator`

compile() {
# clang -isysroot $SDK -arch $ARCH -c $FILE -o $OUTPUT $BITCODE
clang -mios-version-min=8.0 -isysroot $1 -arch $2 -c $3 -o $4 $5
}

compile $SDK_IPHONEOS armv7 test.c test_armv7.o ""
compile $SDK_IPHONEOS armv7 test.c test_armv7_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7 test.c test_armv7_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS armv7s test.c test_armv7s.o ""
compile $SDK_IPHONEOS armv7s test.c test_armv7s_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7s test.c test_armv7s_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS arm64 test.c test_arm64.o ""
compile $SDK_IPHONEOS arm64 test.c test_arm64_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS arm64 test.c test_arm64_bitcode.o -fembed-bitcode

compile $SDK_IPHONEOS armv7 main.c main_armv7.o ""
compile $SDK_IPHONEOS armv7 main.c main_armv7_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7 main.c main_armv7_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS armv7s main.c main_armv7s.o ""
compile $SDK_IPHONEOS armv7s main.c main_armv7s_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7s main.c main_armv7s_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS arm64 main.c main_arm64.o ""
compile $SDK_IPHONEOS arm64 main.c main_arm64_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS arm64 main.c main_arm64_bitcode.o -fembed-bitcode

compile $SDK_IPHONESIMULATOR i386 test.c test_i386.o ""
compile $SDK_IPHONESIMULATOR x86_64 test.c test_x86_64.o ""
compile $SDK_IPHONESIMULATOR i386 main.c main_i386.o ""
compile $SDK_IPHONESIMULATOR x86_64 main.c main_x86_64.o ""

compile $SDK_IPHONEOS armv7 test_armv7.S testS_armv7.o ""
compile $SDK_IPHONEOS armv7 test_armv7.S testS_armv7_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7 test_armv7.S testS_armv7_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS armv7s test_armv7s.S testS_armv7s.o ""
compile $SDK_IPHONEOS armv7s test_armv7s.S testS_armv7s_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS armv7s test_armv7s.S testS_armv7s_bitcode.o -fembed-bitcode
compile $SDK_IPHONEOS arm64 test_arm64.S testS_arm64.o ""
compile $SDK_IPHONEOS arm64 test_arm64.S testS_arm64_marker.o -fembed-bitcode-marker
compile $SDK_IPHONEOS arm64 test_arm64.S testS_arm64_bitcode.o -fembed-bitcode

for suffix in "" _marker _bitcode; do
	for arch in armv7 armv7s arm64; do
		libtool -static test_${arch}${suffix}.o testS_${arch}${suffix}.o -o libtest_${arch}${suffix}.a
	done
done

for arch in armv7 armv7s arm64; do
	clang -dynamiclib -isysroot $SDK_IPHONEOS -arch ${arch} -mios-version-min=8.0 test_${arch}.o  testS_${arch}.o -o libtest_${arch}.dylib
	clang -dynamiclib -isysroot $SDK_IPHONEOS -arch ${arch} -mios-version-min=8.0 test_${arch}_marker.o  testS_${arch}_marker.o -o libtest_${arch}_marker.dylib -fembed-bitcode-marker
	clang -dynamiclib -isysroot $SDK_IPHONEOS -arch ${arch} -mios-version-min=8.0 test_${arch}_bitcode.o  testS_${arch}_bitcode.o -o libtest_${arch}_bitcode.dylib -fembed-bitcode
done

for arch in i386 x86_64; do
	libtool -static test_${arch}.o -o libtest_${arch}.a
    libtool -dynamic -arch_only ${arch} -ios_version_min 11.4 test_${arch}.o -o libtest_${arch}.dylib
done

for ext in .a .dylib; do
	lipo -create libtest_i386${ext} libtest_x86_64${ext} -output libtest_iphonesimulator${ext}
	for suffix in "" _marker _bitcode; do
		lipo -create libtest_armv7${suffix}${ext} libtest_armv7s${suffix}${ext} libtest_arm64${suffix}${ext} -output libtest_iphoneos${suffix}${ext}
		lipo -create libtest_armv7${suffix}${ext} libtest_armv7s${suffix}${ext} libtest_arm64${suffix}${ext} libtest_i386${ext} libtest_x86_64${ext} -output libtest_all${suffix}${ext}
	done
done
