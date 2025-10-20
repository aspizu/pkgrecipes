./configure --prefix=/usr --disable-static
make
make install-strip
chmod -v 0755 $DESTDIR/usr/lib/preloadable_libintl.so
