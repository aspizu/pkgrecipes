sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --no-system-libarchive
make
make DESTDIR=$DESTDIR install
