PAGE=A4 ./configure --prefix=/usr
make
make DESTDIR=$DESTDIR install
