./configure --prefix=/usr --disable-static --disable-dependency-tracking
make
make DESTDIR=$DESTDIR install
