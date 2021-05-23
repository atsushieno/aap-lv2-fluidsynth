# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.6.0)


#get_filename_component (AAPDIR "${CMAKE_CURRENT_LIST_DIR}/../../../dependencies/android-audio-plugin-framework" ABSOLUTE)

set (aap-fluidsynth_INCLUDES
        ../../../../external/lv2
        ../../../../dependencies/fluidsynth/${CMAKE_ANDROID_ARCH_ABI}/include/
        # FIXME: once AGP fixes https://issuetracker.google.com/issues/172105145, we can remove this hack.
        ../../../../aap-include-hack/include/
        )

set (aap-fluidsynth_SOURCES
        fluidsynth-lv2.cpp
        fluid_androidasset.c
        )

add_library (aap-fluidsynth SHARED ${aap-fluidsynth_SOURCES})

if (ANDROID)
    #get_filename_component(AAP_REF_LIB_DIR ${CMAKE_CURRENT_LIST_DIR}/../../../dependencies/android-audio-plugin-framework/java/androidaudioplugin/build/intermediates/library_jni/debug/jni/${CMAKE_ANDROID_ARCH_ABI} ABSOLUTE)
    target_link_directories (aap-fluidsynth
            PUBLIC
            "../../../../dependencies/fluidsynth-deps/dist/${CMAKE_ANDROID_ARCH_ABI}/lib"
            "../../../../dependencies/fluidsynth/${CMAKE_ANDROID_ARCH_ABI}/lib"
            # It is really really really stupid, but due to https://issuetracker.google.com/issues/120166563 (among many other issues) we cannot enable prefab yet, which is
            # supposed to resolve this path to give appropriate -L argument to ld. What we do instead is to download AAP core aar, extract
            # its content, and give its path to libandroidaudioplugin.so. It is really absurd, and not safe, but there is no other way.
            "../../../../dependencies/androidaudioplugin-aar/jni/${CMAKE_ANDROID_ARCH_ABI}"
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

target_link_libraries (aap-fluidsynth android log androidaudioplugin fluidsynth)

