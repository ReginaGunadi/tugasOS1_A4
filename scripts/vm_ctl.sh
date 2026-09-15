#!/bin/bash

invalid_command() {
    echo "vm_ctl: command tidak valid '$1'" >&2
    exit 1
}

vm_name_input_checker() {
    local nama_vm="$1"

    # Kondisi: inputnya kosong
    if [ -z "$nama_vm" ]; then
        echo "vm_ctl: nama VM harus diisi"
        exit 1
    fi 

    # Kondisi: nama VM tidak ada di list
    if ! VBoxManage list vms | grep -q "$nama_vm"; then
        echo "vm_ctl: VM '$nama_vm' tidak ditemukan" >&2
        exit 1
    fi

    # Kondisi: valid -> tampilkan informasi tentang VM terkait 
    vm_info "$nama_vm"
}

vm_info() {
    local nama_vm="$1" 
    
    # Ambil informasi dari VM yang dicari
    all_info=$(VBoxManage showvminfo "$nama_vm")
    
    # Ekstrak informasi: RAM, vCPU, dan status
    ram=$(echo "$all_info" | grep "Memory size" | awk '{print $3}')
    vcpu=$(echo "$all_info" | grep "Number of CPUs" | awk '{print $4}')
    status=$(echo "$all_info" | grep "State" | awk '{print $2}')

    # Tampilkan informasi
    echo "VM                  : $nama_vm"
    echo "RAM dialokasikan    : $ram"
    echo "vCPU dialokasikan   : $vcpu"
    echo "Status saat ini     : $status"
}


#./vm_ctl.sh list

#./vm_ctl.sh info <nama_vm>

#./vm_ctl.sh start <nama_vm> dan ./vm_ctl.sh stop <nama_vm>

#./vm_ctl.sh snapshot create <nama_vm> <nama_snapshot>  dan ./vm_ctl.sh snapshot list <nama_vm> 

header="===================================\nTUGAS 1 OS - KELOMPOK A04\n===================================" 

case "$1" in
    list)
        echo -e "$header"
        VBoxManage list vms
        ;;
    info)
        echo -e "$header"
        nama_vm="$2"
        vm_name_input_checker "$nama_vm"
        ;;
    start)
        echo -e "$header"
        #Code
        ;;
    snapshot)
        echo -e "$header"
        #Code
        ;;
    *)
        invalid_command $1
        ;;
esac