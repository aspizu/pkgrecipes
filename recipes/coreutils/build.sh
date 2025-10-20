autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --libexecdir=/usr/lib --with-openssl --enable-no-install-program=kill,uptime
make
make DESTDIR=$DESTDIR install
mv $DESTDIR/usr/bin/chroot $DESTDIR/usr/sbin
mv $DESTDIR/usr/share/man/man1/chroot.1 $DESTDIR/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $DESTDIR/usr/share/man/man8/chroot.8
