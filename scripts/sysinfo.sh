#!/bin/bash

# Info OS/kernel
KERNEL_NAME=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_VERSION=$(uname -v)
ARCH=$(uname -m)

# Jumlah akun pengguna biasa
LOGGED_USERS=&(getent passwd | grep -vE 'nologin|false' | wc -l)