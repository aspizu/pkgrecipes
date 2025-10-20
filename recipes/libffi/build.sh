./configure --prefix=/usr --disable-static --without-gcc-arch
make
make DESTDIR=$DESTDIR install
