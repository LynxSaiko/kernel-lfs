#!/bin/bash

# Pastikan Anda menjalankan skrip ini dengan hak akses root atau gunakan sudo

# Langkah 4: Membuat `mozconfig` untuk Build yang Ringan
echo "Membuat konfigurasi mozconfig..."
cat > mozconfig << "EOF"
# Menonaktifkan Wi-Fi geolokasi (jika tidak diperlukan)
ac_add_options --disable-necko-wifi

# Menonaktifkan penggunaan hardware acceleration (WebRender)
ac_add_options --disable-webrender

# Menonaktifkan WebGL (meminimalkan penggunaan GPU)
ac_add_options --disable-webgl

# Menonaktifkan crash reporter dan updater
ac_add_options --disable-crashreporter
ac_add_options --disable-updater

# Menonaktifkan pengumpulan data (telemetri) Mozilla
unset MOZ_TELEMETRY_REPORTING

# Menonaktifkan tes (hemat waktu dan ruang disk)
ac_add_options --disable-tests

# Menggunakan sistem pustaka jika sudah terpasang
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# Mengaktifkan optimasi build dan menonaktifkan debug symbols
ac_add_options --disable-debug-symbols
ac_add_options --enable-optimize

# Menonaktifkan WebAssembly sandboxed libraries untuk menghindari penurunan kinerja
ac_add_options --without-wasm-sandboxed-libraries

# Menonaktifkan PulseAudio dan ALSA (audio backend tidak digunakan)
ac_add_options --enable-audio-backends=none

# Konfigurasi default
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser
EOF

# Langkah 5: Mengatasi Masalah dengan `cbindgen`
echo "Mengatasi masalah dengan cbindgen..."
sed -i '/ROOT_CLIP_CHAIN/d' gfx/webrender_bindings/webrender_ffi.h

# Langkah 6: Mengonfigurasi Build
echo "Mengonfigurasi build..."
export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system
export MOZBUILD_STATE_PATH=${PWD}/mozbuild
./mach configure

# Langkah 7: Memulai Proses Build
echo "Memulai proses build..."
./mach build -j$(nproc)

# Langkah 8: Instalasi Firefox
echo "Instalasi Firefox..."
MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system ./mach install

# Langkah 9: Pembersihan Variabel Lingkungan
echo "Membersihkan variabel lingkungan..."
unset MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE MOZBUILD_STATE_PATH

# Langkah 10: Verifikasi Pengaturan
echo "Verifikasi pengaturan Firefox..."
echo "Buka 'about:support' di Firefox untuk memastikan WebRender dan hardware acceleration telah dinonaktifkan."

echo "Build dan instalasi Firefox selesai!"
