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

# Bagian nama kernel aku masih gak yakin ngambil yang mana 
echo "OS/Kernel        :'$KERNEL_NAME' ($KERNEL_VERSION)" 
echo "Akun Pengguna    : $LOGGED_USERS akun"
echo "Proses Berjalan  : $RUNNING_PROCESS proses"
echo "Virtualisasi     : $VIRT_STATUS"

echo ""
echo "Menghitung metrik varian kelompok..."

# Menghitung persentase usage memory dan swap
MEM_FREE_TOTAL=$(free | awk 'NR == 2 { printf "%d / %d", $3, $2 }') 
MEM=$(echo "$MEM_FREE_TOTAL * 100" | bc -l)

SWAP_FREE_TOTAL=$(free | awk 'NR == 3 { printf "%d / %d", $3, $2 }')
SWAP=$(echo "$SWAP_FREE_TOTAL * 100" | bc -l)

# Memberi input ke resource-check dan mengambil outputnya
METRIC_VERDICT=$(echo $MEM $SWAP | ./resource-check)
MEM_VERDICT=$(echo $METRIC_VERDICT | awk '{ print $1 }')
SWAP_VERDICT=$(echo $METRIC_VERDICT | awk '{ print $2 }')

printf "Memory usage  : %02.0f%%   [ $MEM_VERDICT ]\n" $MEM
printf "Swap usage    : %02.0f%%   [ $SWAP_VERDICT ]\n" $SWAP
