./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make DESTDIR=$DESTDIR install
