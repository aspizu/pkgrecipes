./configure --prefix=/usr --disable-debuginfod --enable-libdebuginfod=dummy
make
make -C libelf DESTDIR=$DESTDIR install
install -Dm644 config/libelf.pc $DESTDIR/usr/lib/pkgconfig/libelf.pc
rm $DESTDIR/usr/lib/libelf.a
