
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a

all: build-all

build-all: \
	get-prebuilt-deps \
	build-fluidsynth-android \
	build-aap-lv2 \
	build-java

## downloads

get-prebuilt-deps: dependencies/fluidsynth-deps/dist/stamp

dependencies/fluidsynth-deps/dist/stamp: aap-guitarix-binaries.zip androidaudioplugin-debug.aar
	unzip aap-guitarix-binaries.zip -d dependencies/fluidsynth-deps
	unzip androidaudioplugin-debug.aar -d dependencies/androidaudioplugin-aar
	bash rewrite-pkg-config-paths.sh fluidsynth-deps
	mkdir -p aap-fluidsynth/src/main/jniLibs/armeabi-v7a && cp dependencies/fluidsynth-deps/dist/armeabi-v7a/lib/*.so aap-fluidsynth/src/main/jniLibs/armeabi-v7a
	mkdir -p aap-fluidsynth/src/main/jniLibs/arm64-v8a && cp dependencies/fluidsynth-deps/dist/arm64-v8a/lib/*.so aap-fluidsynth/src/main/jniLibs/armeabi-v7a
	mkdir -p aap-fluidsynth/src/main/jniLibs/x86 && cp dependencies/fluidsynth-deps/dist/x86/lib/*.so aap-fluidsynth/src/main/jniLibs/armeabi-v7a
	mkdir -p aap-fluidsynth/src/main/jniLibs/x86_64 && cp dependencies/fluidsynth-deps/dist/x86_64/lib/*.so aap-fluidsynth/src/main/jniLibs/armeabi-v7a
	touch dependencies/fluidsynth-deps/dist/stamp

aap-guitarix-binaries.zip:
	wget https://github.com/atsushieno/android-native-audio-builders/releases/download/r6/aap-guitarix-binaries.zip

androidaudioplugin-debug.aar:
	wget https://github.com/atsushieno/android-audio-plugin-framework/releases/download/v0.5.5/androidaudioplugin-debug.aar

## Build utility

build-fluidsynth-android:
	make -f Makefile.android ANDROID_NDK=$(ANDROID_NDK) build-fluidsynth dist-fluidsynth

build-aap-lv2:
	cd external/aap-lv2 && make build-non-app

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build
 
