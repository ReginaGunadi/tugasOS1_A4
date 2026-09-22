#!/bin/bash

header="===================================\nTUGAS 1 OS - KELOMPOK A04\n===================================" 

# Info OS/kernel
if [ -f /etc/os-release ]; then
    . /etc/os-release
    # Mengambil 'nama cantik' dari current OSnya, seperti "Ubuntu 24.04 LTS"
    OS_NAME="$PRETTY_NAME"
else
    OS_NAME=$(uname -s) # Else, mengambil "Linux"
fi

# Mengambil release version dari current OS dengan memotong pada bagian dengan "-"
KERNEL_REL=$(uname -r | cut -d'-' -f1)
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
echo "OS/Kernel        :$OS_NAME ($KERNEL_REL)" 
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
METRIC_VERDICT=$(echo $MEM $SWAP | ./resource_check)
MEM_VERDICT=$(echo $METRIC_VERDICT | awk '{ print $1 }')
SWAP_VERDICT=$(echo $METRIC_VERDICT | awk '{ print $2 }')

printf "Memory usage  : %02.0f%%   [ $MEM_VERDICT ]\n" $MEM
printf "Swap usage    : %02.0f%%   [ $SWAP_VERDICT ]\n" $SWAP

# Bulatkan angka desimal ke 2 angka di belakang koma
MEM_ROUNDED=$(printf "%.2f" "$MEM")
SWAP_ROUNDED=$(printf "%.2f" "$SWAP")

# Tentukan deskripsi Details berdasarkan status
case "$MEM_VERDICT" in
    PASS) MEM_DETAIL="Normal" ;;
    WARN) MEM_DETAIL="Mulai penuh" ;;
    FAIL) MEM_DETAIL="Kritis" ;;
    *) MEM_DETAIL="Tidak diketahui" ;;
esac

case "$SWAP_VERDICT" in
    PASS) SWAP_DETAIL="Normal" ;;
    WARN) SWAP_DETAIL="Mulai terpakai" ;;
    FAIL) SWAP_DETAIL="Kritis" ;;
    *) SWAP_DETAIL="Tidak diketahui" ;;
esac

echo ""
echo "Menyimpan laporan ke sysinfo_report.txt..."

REPORT_FILE="sysinfo_report.txt"

{
    echo "=========================================================================="
    echo "                       TUGAS 1 OS - KELOMPOK A04"
    echo "=========================================================================="
    printf "+%-16s+%-19s+%-8s+%-27s+\n" "----------------" "-------------------" "--------" "---------------------------"
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Check Category " " Item " " Status " " Details "
    printf "+%-16s+%-19s+%-8s+%-27s+\n" "----------------" "-------------------" "--------" "---------------------------"
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " OS " " $KERNEL_NAME " " PASS " " $KERNEL_VERSION "
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Users " " Regular accounts " " PASS " " $LOGGED_USERS akun "
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Processes " " Running " " PASS " " $RUNNING_PROCESS proses "
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Virtualization " " Hypervisor " " PASS " " $VIRT_STATUS "
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Memory " " ${MEM_ROUNDED}% " " $MEM_VERDICT " " $MEM_DETAIL "
    printf "|%-16s|%-19s|%-8s|%-27s|\n" " Swap " " ${SWAP_ROUNDED}% " " $SWAP_VERDICT " " $SWAP_DETAIL "
    printf "+%-16s+%-19s+%-8s+%-27s+\n" "----------------" "-------------------" "--------" "---------------------------"
} > "$REPORT_FILE"

echo "Laporan berhasil disimpan."