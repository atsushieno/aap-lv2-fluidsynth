# aap-lv2-fluidsynth: Fluidsynth plugin for AAP via LV2

This repository is for [Fluidsynth](https://github.com/FluidSynth/fluidsynth) plugin example for [AAP](https://github.com/atsushieno/android-audio-plugin-framework/). It is powered by LV2 using [aap-lv2](https://github.com/atsushieno/aap-lv2/).

The plugin application itself is not really featureful yet. The SoundFont file is fixed as FluidR3_GM.sf3 in the C++ code. It can be made customizible, but it does not happen yet.

## Building

`make` should take care of the builds. See [GitHub Actions script](.github/workflows/actions.yml) for further normative setup.

## Hacking

In this repo, we build fluidsynth for Android without Oboe and OpenSLES, unlike the official build does (the official build script is written by atsushieno as well). It is simply because we only need synthesizer part without native audio access.

While Fluidsynth build is CMake based, it could not simply specified in build.gradle (it fails to compile). Therefore we use somewhat modified version of the build script (Makefile.android) from the official repo.

It still heavily depends on glib, so we use artifacts from [atsushieno/android-native-audio-builders](https://github.com/atsushieno/android-native-audio-builders/) repo.

LV2 plugin implementation is quite simple (maybe too simple). There is no parameters exposed, and states to persistize. There are many rooms to improve.

## Licensing notice

aap-lv2-fluidsynth codebase is distributed under the MIT license.

LV2 (repository for the headers) is under the ISC license.

`fluidsynth` is distributed under the LGPL v2.1 license.

`aap-fluidsynth/src/main/assets/FluidR3Mono_GM.sf3` is a binary copy of the same file from [`fluidr3mono-gm-soundfont` debian package](https://ubuntu.pkgs.org/18.04/ubuntu-universe-amd64/fluidr3mono-gm-soundfont_2.315-4_all.deb.html) and it is licensed under the MIT license.

The entire plugin application bundles `androidaudioplugin-lv2` AAR module from `aap-lv2`, and `androidaudioplugin` AAR module, and is packaged into one application.
