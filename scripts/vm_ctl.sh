#!/bin/bash

#./vm_ctl.sh list

#./vm_ctl.sh info <nama_vm>

#./vm_ctl.sh start <nama_vm> dan ./vm_ctl.sh stop <nama_vm>

#./vm_ctl.sh snapshot create <nama_vm> <nama_snapshot>  dan ./vm_ctl.sh snapshot list <nama_vm> 

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
    snapshot create)
        #Code
        ;;
esac
