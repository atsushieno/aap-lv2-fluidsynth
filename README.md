# aap-lv2-fluidsynth: Fluidsynth plugin for AAP via LV2

This repository is for Fluidsynth plugin example for [AAP](https://github.com/atsushieno/android-audio-plugin-framework/). It is powered by LV2 using [aap-lv2](https://github.com/atsushieno/aap-lv2/).

The plugin application itself is not really featureful yet. The SoundFont file is fixed as FluidR3_GM.sf3 in the C++ code. It can be made customizible, but it does not happen yet.

## Building

`make` should take care of the builds. See [GitHub Actions script](.github/workflows/actions.yml) for further normative setup.


## Licensing notice

aap-lv2-fluidsynth codebase is distributed under the MIT license.

LV2 (repository for the headers) is under the ISC license.

`fluidsynth` is distributed under the LGPL v2.1 license.

`aap-fluidsynth/src/main/assets/FluidR3Mono_GM.sf3` is a binary copy of the same file from [`fluidr3mono-gm-soundfont` debian package](https://ubuntu.pkgs.org/18.04/ubuntu-universe-amd64/fluidr3mono-gm-soundfont_2.315-4_all.deb.html) and it is licensed under the MIT license.

The entire plugin application bundles `androidaudioplugin-lv2` AAR module from `aap-lv2`, and `androidaudioplugin` AAR module, and is packaged into one application.
