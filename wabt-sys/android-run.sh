#!/bin/bash

# Ref:
# https://github.com/Dushistov/rust_swig/blob/cfd12fb7406f9f2774832c051ce7b4e6c2e193d7/android-tests/run-on-android.sh
# https://github.com/rust-lang/libc/blob/7477c68275b1b6da3e8ce81d0545c9484236b35f/ci/docker/aarch64-linux-android/Dockerfile

set -eu

exe_path="$1"
shift

args="$@"

exe_name="$(basename "$exe_path")"

adb push "$exe_path" "/data/local/tmp/$exe_name"
adb shell "chmod 755 /data/local/tmp/$exe_name"
#out="$(mktemp)"
adb shell "RUST_LOG=debug /data/local/tmp/$exe_name ${args[@]}" 2>&1
#mark="$0: !!!!!!!!!!!!!!!!!!!!!!!! FINISHED !!!!!!!!!!!!!!!!!!!!!!!!!!"
#adb shell "RUST_LOG=debug /data/local/tmp/$exe_name  ${args[@]}; echo $mark" 2>&1 | tee "$out"
#grep -F "$mark" "$out"
