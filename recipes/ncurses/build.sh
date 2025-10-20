./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make install
for lib in ncurses form panel menu ; do
    ln -sf lib${lib}w.so $DESTDIR/usr/lib/lib${lib}.so
    ln -sf ${lib}w.pc    $DESTDIR/usr/lib/pkgconfig/${lib}.pc
done
ln -sfv libncursesw.so $DESTDIR/usr/lib/libcurses.so
