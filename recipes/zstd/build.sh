./configure --prefix=/usr
make prefix=/usr
make prefix=/usr install
rm $DESTDIR/usr/lib/libzstd.a
