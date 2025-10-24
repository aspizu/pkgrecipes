./configure --prefix=/usr --disable-static --enable-man --disable-dependency-tracking
make
make DESTDIR=$DESTDIR install
