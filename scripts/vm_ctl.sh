#!/bin/bash

invalid_command() {
    echo "vm_ctl: command tidak valid '$1'" >&2
    exit 1
}

#./vm_ctl.sh list

#./vm_ctl.sh info <nama_vm>

#./vm_ctl.sh start <nama_vm> dan ./vm_ctl.sh stop <nama_vm>

#./vm_ctl.sh snapshot create <nama_vm> <nama_snapshot>  dan ./vm_ctl.sh snapshot list <nama_vm> 

snapshot() {
    case "$1" in
        create)
            local timestamp=$(date +"%Y-%m-%d %T")
            local timestampf=$(date +"%Y_%m_%d_%H-%M-%S")
            echo "Membuat snapshot '$3' pada VM '$2'..."
            { 
                VBoxManage snapshot "$2" take "$3-$timestampf" &> /dev/null &&
                    echo "Snapshot '$3' berhasil dibuat pada $timestamp"

            } || echo "vm_ctl: terjadi error, cek penamaan OS" 
            ;;
        list)
            VBoxManage snapshot "$2" list || echo "vm_ctl: terjadi error, cek penamaan OS"
            ;;
        *)
            invalid_command $1
            ;;
    esac
}

case "$1" in
    list)
        VBoxInfoManage list vms
        ;;
    info)
        #Code
        ;;
    start)
        #Code
        ;;
    snapshot)
        shift
        snapshot $@
        ;;
    *)
        invalid_command $1
        ;;
esac
