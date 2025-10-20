autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --libexecdir=/usr/lib --with-openssl --enable-no-install-program=kill,uptime
make
make DESTDIR=$DESTDIR install
mkdir -p /usr/sbin /usr/share/man/man8
mv $DESTDIR/usr/bin/chroot $DESTDIR/usr/sbin
