./configure --prefix=/usr --buildtype=release
make
make DESTDIR=$DESTDIR install
