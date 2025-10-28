./configure --prefix=/usr --sbindir=/usr/bin --sysconfdir=/etc
make
make DESTDIR=$DESTDIR install
