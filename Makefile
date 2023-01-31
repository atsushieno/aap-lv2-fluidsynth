
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a
ifeq ('$(ANDROID_SDK_ROOT)', '')
ANDROID_SDK_ROOT=~/Android/Sdk
endif
ANDROID_NDK=$(ANDROID_SDK_ROOT)/ndk/24.0.8215888

all: build-all

build-all: \
	build-aap-lv2 \
	build-native \
	build-java

build-native: dependencies/stamp-fluidsynth dependencies/stamp-aap-aar

external/fluidsynth/.patch-stamp:
	cd external/fluidsynth && patch -i ../../fluidsynth-ndk24.patch -p1 && touch .patch-stamp

external/fluidsynth/test-android/build-scripts/archives/.stamp: external/fluidsynth/.patch-stamp
	cd external/fluidsynth/test-android/build-scripts && bash ./download.sh && touch archives/.stamp

dependencies/stamp-fluidsynth: make-jniLibsDir external/fluidsynth/test-android/build-scripts/archives/.stamp
	cd external/fluidsynth/test-android/build-scripts &&  NDK=$(ANDROID_NDK) bash ./build-all-archs.sh
	cp -R external/fluidsynth/test-android/build-scripts/build-artifacts/lib/*	app/src/main/jniLibs/
	rm -f app/src/main/jniLibs/*/libc++_shared.so
	touch dependencies/stamp-fluidsynth

make-jniLibsDir:
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p app/src/main/jniLibs/$$a ; \
	done

dependencies/stamp-aap-aar:
	cp external/aap-lv2/external/aap-core/androidaudioplugin/build/outputs/aar/androidaudioplugin-release.aar .
	unzip androidaudioplugin-release.aar -d dependencies/androidaudioplugin-aar
	touch dependencies/stamp-aap-aar

build-aap-lv2:
	cd external/aap-lv2 && make build-non-app

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build bundle
 
