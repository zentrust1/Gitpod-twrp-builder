#!/bin/bash

# Mengambil direktori saat ini
current_directory=$(pwd)

# Pindah ke direktori /workspace/twrp atau buat jika belum ada
mkdir -p /workspace/twrp
cd /workspace/twrp

# Baca file setting.txt
source ${current_directory}/setting.txt

# Tampilkan informasi dari setting.txt
echo "Manifest URL: ${manifest_url}"
echo "Manifest branch: ${manifest_branch}"
echo "Link Device tree twrp: ${Device_tree}"
echo "Branch Device tree twrp: ${Branch_dt_twrp}"
echo "Device Path: ${Device_Path}"
echo "Device Name: ${Device_Name}"
echo "Build Target (recovery, boot): ${Build_Target}"

# Instalasi dependensi yang diperlukan
apt update
apt -y upgrade
apt -y install gperf gcc-multilib g++-multilib libc6-dev-i386 \
    lib32ncurses5-dev x11proto-core-dev libx11-dev tree lib32z-dev \
    libgl1-mesa-dev libxml2-utils xsltproc bc ccache \
    liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev \
    libxml2 lzop pngcrush schedtool squashfs-tools imagemagick \
    libbz2-dev lzma ncftp qemu-user-static python3-lxml rsync \
    repo git-core gnupg flex bison build-essential zip curl \
    zlib1g-dev gcc-arm-linux-gnueabi libssl-dev \
    libncurses5 libstdc++6 python python2 python3 python-dev \
    python3-dev libffi-dev libssl-dev libncurses5-dev \
    zlib1g-dev wget -y

# Konfigurasi git
git config --global user.name "Massatrio16"
git config --global user.email "dimassetosatrio@gmail.com"

# Inisialisasi repo dan sinkronisasi
repo init --depth=1 -u ${manifest_url} -b ${manifest_branch}
repo sync

# Klon device tree twrp
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}

# Membangun recovery atau boot image
sleep 2
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
cd ${Device_Path}
lunch omni_${Device_Name}-eng
mka ${Build_Target}image

# Menyalin output ke direktori saat ini
output_file="../../../out/target/product/${Device_Name}/${Build_Target}.img"
cp -r ${output_file} ${current_directory}

# Upload ke Telegram jika variabel chat_id dan bot_token sudah disetel di setting.txt
if [ ! -z "${chat_id}" ] && [ ! -z "${bot_token}" ]; then
    curl -F chat_id=${chat_id} -F document=@${output_file} "https://api.telegram.org/bot${bot_token}/sendDocument"
else
    echo "Variabel chat_id dan bot_token belum diatur, file tidak diunggah ke Telegram."
fi

echo "Proses build TWRP selesai."
