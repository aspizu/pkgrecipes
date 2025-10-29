cd source
./configure --prefix=/usr
make
make DESTDIR=$DESTDIR install
