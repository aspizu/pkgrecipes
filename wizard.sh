#!/usr/bin/env bash
set -e

if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage ./wizard.sh PACKAGE_NAME VERSION_NUMBER"
    exit 1
fi

if [[ -d recipes/$1 ]]; then
    echo "Package $1 already exists."
    exit 1
fi

mkdir recipes/$1
cd recipes/$1

cat << EOF > manifest.toml
name = "$1"
version = "$2"
release = 1
dependencies = []
source = ""
EOF

cat << EOF > build.sh
./configure --prefix=/usr
make
make install
EOF
