
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a
ANDROID_NDK=$(ANDROID_SDK_ROOT)/ndk/21.3.6528147

all: build-all

build-all: \
	build-aap-lv2 \
	build-native \
	build-java

build-native: dependencies/fluidsynth-deps/dist/stamp dependencies/fluidsynth-deps/dist/stamp-aap-aar

external/fluidsynth/test-android/build-scripts/archives/.stamp:
	cd external/fluidsynth/test-android/build-scripts && bash ./download.sh && touch archives/.stamp

dependencies/fluidsynth-deps/dist/stamp: make-jniLibsDir external/fluidsynth/test-android/build-scripts/archives/.stamp
	cd external/fluidsynth/test-android/build-scripts && bash ./build-all-archs.sh
	cp -R external/fluidsynth/test-android/build-scripts/build-artifacts/lib/*	aap-fluidsynth/src/main/jniLibs/
	rm -f aap-fluidsynth/src/main/jniLibs/*/libc++_shared.so
	touch dependencies/fluidsynth-deps/dist/stamp

make-jniLibsDir:
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p aap-fluidsynth/src/main/jniLibs/$$a ; \
	done

dependencies/fluidsynth-deps/dist/stamp-aap-aar:
	cp external/aap-lv2/dependencies/android-audio-plugin-framework/java/androidaudioplugin/build/outputs/aar/androidaudioplugin-debug.aar .
	unzip androidaudioplugin-debug.aar -d dependencies/androidaudioplugin-aar
	touch dependencies/fluidsynth-deps/dist/stamp-aap-aar

build-aap-lv2:
	cd external/aap-lv2 && make build-non-app

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build
 