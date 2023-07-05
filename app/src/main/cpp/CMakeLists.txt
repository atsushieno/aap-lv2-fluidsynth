# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.6.0)

set (aap-fluidsynth_INCLUDES
        ../../../../external/lv2
        ../../../../external/fluidsynth/test-android/build-scripts/build-artifacts/include/
        )

set (aap-fluidsynth_SOURCES
        fluidsynth-lv2.cpp
        fluid_androidasset.c
        android-application-context.cpp
        )

add_library (aap-fluidsynth SHARED ${aap-fluidsynth_SOURCES})

if (ANDROID)
    target_link_directories (aap-fluidsynth
            PUBLIC
            "../jniLibs/${CMAKE_ANDROID_ARCH_ABI}"
            )
endif (ANDROID)

target_include_directories (aap-fluidsynth
        PRIVATE
        ${aap-fluidsynth_INCLUDES}
        )

target_link_directories (aap-fluidsynth
        PRIVATE
        jniLibs/${CMAKE_ANDROID_ARCH_ABI})

target_compile_options (aap-fluidsynth
        PRIVATE
        -Wall
        -Wextra-semi
        -Wshadow
        -Wshadow-field
        )

find_package(androidaudioplugin REQUIRED CONFIG)
find_package(androidaudioplugin-lv2 REQUIRED CONFIG)

target_link_libraries (aap-fluidsynth
        android
        log
        androidaudioplugin::androidaudioplugin
        androidaudioplugin-lv2::androidaudioplugin-lv2
        fluidsynth)

# You can set it via build.gradle.
if (${AAP_ENABLE_ASAN})
    target_compile_options (aap-fluidsynth
            PUBLIC
            -fsanitize=address -fno-omit-frame-pointer
            )

    target_link_options(aap-fluidsynth
            PUBLIC
            -fsanitize=address
            )

    set_target_properties(aap-fluidsynth
            PROPERTIES LINK_FLAGS -fsanitize=address
            )
endif()
