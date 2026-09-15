#!/bin/bash

header="===================================\nTUGAS 1 OS - KELOMPOK A04\n===================================" 

# Info OS/kernel
KERNEL_NAME=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_VERSION=$(uname -v)
ARCH=$(uname -m)

# Jumlah akun pengguna biasa
LOGGED_USERS=$(getent passwd | grep -vE 'nologin|false' | wc -l)

# Jumlah proses yang berjalan
RUNNING_PROCESS=$(ps -e | wc -l)

# Deteksi sistem yang berjalan di VM
if [ -f /sys/class/dmi/id/product_name ]; then
    VIRT_NAME=$(cat /sys/class/dmi/id/product_name)
    VIRT_STATUS="Terdeteksi ($VIRT_NAME)"
else
    VIRT_STATUS="Tidak terdeteksi"
fi


# Tampilan string formatting
echo -e "$header"
echo "Mengecek Sistem..."
echo "OS/Kernel        :'$KERNEL_NAME' ($KERNEL_VERSION)" 
echo "Akun Pengguna    : $LOGGED_USERS akun"
echo "Proses Berjalan  : $RUNNING_PROCESS proses"
echo "Virtualisasi     : $VIRT_STATUS"
