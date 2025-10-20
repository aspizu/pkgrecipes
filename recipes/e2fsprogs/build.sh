mkdir -v build
cd       build
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck
make
make DESTDIR=$DESTDIR install
rm -fv $DESTDIR/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
