./configure --prefix=/usr
make
make install
rm -f $DESTDIR/usr/lib/libz.a
