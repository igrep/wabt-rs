# docker build -t android-sdk-ndk .

FROM ubuntu:19.10

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
  file \
  curl \
  ca-certificates \
  python \
  unzip \
  expect \
  openjdk-8-jre \
  libstdc++6:i386 \
  libpulse0 \
  gcc \
  libc6-dev

#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --profile=minimal
#RUN rustup default stable-aarch64-linux-android

WORKDIR /android/
COPY android* /android/

ENV ANDROID_ARCH=aarch64
ENV PATH=$PATH:/android/ndk-$ANDROID_ARCH/bin:/android/sdk/tools:/android/sdk/platform-tools

RUN sh /android/android-install-sdk.sh $ANDROID_ARCH
RUN sh /android/android-install-ndk.sh $ANDROID_ARCH
RUN mv /root/.android /tmp
RUN chmod 777 -R /tmp/.android
RUN chmod 755 /android/sdk/tools/* /android/sdk/emulator/qemu/linux-x86_64/*

ENV PATH=$PATH:/rust/bin \
    HOME=/tmp
    #CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-gcc \

RUN mkdir /tmp/test
COPY wabt-sys/target/aarch64-linux-android/debug/deps/ /tmp/test

ENTRYPOINT [ \
  "bash", \
  "-c", \
  # set SHELL so android can detect a 64bits system, see
  # http://stackoverflow.com/a/41789144
  "SHELL=/bin/dash /android/sdk/emulator/emulator @aarch64 -no-window & \
   exec \"$@\"", \
  "--" \
]
