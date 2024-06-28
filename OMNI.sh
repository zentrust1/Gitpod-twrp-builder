#!/bin/bash

current_directory=$(pwd)

cd /workspace
mkdir -p twrp
cd twrp

# Membaca file input
source ${current_directory}/setting.txt

echo "Manifest URL: ${manifest_url}"
echo "Manifest branch: ${manifest_branch}"

echo "Link Device tree twrp: ${Device_tree}"
echo "Branch Device tree twrp: ${Branch_dt_twrp}"
echo "Device Path: ${Device_Path}"
echo "Device Name: ${Device_Name}"
echo "Build Target (recovery, boot): ${Build_Target}"

# Instalasi dependensi
apt update
apt -y upgrade
apt -y install gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma ncftp qemu-user-static libstdc++-10-dev libtinfo5 nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && apt install build-essential -y && apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && apt install pigz -y && apt install python2 -y && apt install python3 -y && apt install cpio -y && apt install lld -y && apt install llvm -y && apt -y install libncurses5 && apt -y install rsync && apt -y install repo

# Konfigurasi git
git config --global user.name "Massatrio16"
git config --global user.email "dimassetosatrio@gmail.com"

# Inisialisasi repo dan sinkronisasi
repo init --depth=1 -u ${manifest_url} -b ${manifest_branch}
repo sync

# Klon device tree
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}

# Membangun recovery
sleep 2
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
cd ${Device_Path}
lunch omni_${Device_Name}-eng
mka ${Build_Target}image

# Menyalin output
output_file="../../../out/target/product/${Device_Name}/${Build_Target}.img"
cp -r ${output_file} ${current_directory}

# Upload ke Telegram
curl -F chat_id=${chat_id} -F document=@${output_file} "https://api.telegram.org/bot${bot_token}/sendDocument"
