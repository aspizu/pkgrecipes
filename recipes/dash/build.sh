./configure --prefix=/usr
make
make DESTDIR=$DESTDIR install
ln -s dash $DESTDIR/usr/bin/sh
