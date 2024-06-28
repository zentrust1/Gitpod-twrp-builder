FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev \
    tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev \
    libsdl1.2-dev libwxgtk3.0-gtk3-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma ncftp \
    qemu-user-static libstdc++-10-dev libtinfo5 nano ca-certificates curl flex git libssl-dev openssl python-is-python3 \
    ssh wget zip zstd make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools \
    gcc-aarch64-linux-gnu python2 python3 cpio lld llvm libncurses5 rsync repo

# Install repo tool
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo

# Set up environment variables
ENV ALLOW_MISSING_DEPENDENCIES=true
ENV LC_ALL=C
