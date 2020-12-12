#!/bin/bash

var1="Sun/OS"
var2="Sun/OS"
var3="arch
var4="2021.01.01"
var5="Mount Bonnell
var6="38;2;23;147;209"
var7="archlinux"
cat > /etc/os-release << EOF1
NAME="$var1"
PRETTY_NAME="$var2"
ID="$var3"
VERSION="$var4"
VERSION_CODENAME="$var5"
ANSI_COLOR="$var6"
LOGO="$var7"
EOF1
