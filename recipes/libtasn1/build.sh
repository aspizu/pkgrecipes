./configure --prefix=/usr --disable-static
make
make DESTDIR=$DESTDIR install
