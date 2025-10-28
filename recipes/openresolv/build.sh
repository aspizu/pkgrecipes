./configure --prefix=/usr --sysconfdir=/etc
make
make DESTDIR=$DESTDIR install
