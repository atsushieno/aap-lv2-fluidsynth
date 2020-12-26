
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a
ANDROID_NDK=$(ANDROID_SDK_ROOT)/ndk/21.2.6472646

all: build-all

build-all: \
	build-aap-lv2 \
	get-prebuilt-deps \
	build-fluidsynth-android \
	build-java

## downloads

get-prebuilt-deps: dependencies/fluidsynth-deps/dist/stamp

dependencies/fluidsynth-deps/dist/stamp: aap-guitarix-binaries.zip androidaudioplugin-debug.aar
	unzip aap-guitarix-binaries.zip -d dependencies/fluidsynth-deps
	rm -f dependencies/fluidsynth-deps/dist/*/lib/libc++_shared.so
	unzip androidaudioplugin-debug.aar -d dependencies/androidaudioplugin-aar
	rm -f dependencies/androidaudioplugin-aar/jni/*/libc++_shared.so
	bash rewrite-pkg-config-paths.sh fluidsynth-deps
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p aap-fluidsynth/src/main/jniLibs/$$a ; \
		cp -R dependencies/fluidsynth-deps/dist/$$a/lib/*.so aap-fluidsynth/src/main/jniLibs/$$a ; \
	done
	touch dependencies/fluidsynth-deps/dist/stamp

aap-guitarix-binaries.zip:
	wget https://github.com/atsushieno/android-native-audio-builders/releases/download/r8.3/aap-guitarix-binaries.zip

androidaudioplugin-debug.aar:
	wget https://github.com/atsushieno/android-audio-plugin-framework/releases/download/v0.5.5/androidaudioplugin-debug.aar

## Build utility

build-fluidsynth-android:
	make -f Makefile.android ANDROID_NDK=$(ANDROID_NDK) build-fluidsynth dist-fluidsynth
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p aap-fluidsynth/src/main/jniLibs/$$a ; \
		cp dependencies/fluidsynth/$$a/lib/*.so aap-fluidsynth/src/main/jniLibs/$$a ; \
	done

build-aap-lv2:
	cd external/aap-lv2 && make build-non-app

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build
 
