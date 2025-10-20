./configure --prefix=/usr
make
make install-strip
rm -fv $DESTDIR/usr/lib/libltdl.a
