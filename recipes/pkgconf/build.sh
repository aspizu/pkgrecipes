./configure --prefix=/usr --disable-static
make
make install
ln -s pkgconf   $DESTDIR/usr/bin/pkg-config
ln -s pkgconf.1 $DESTDIR/usr/share/man/man1/pkg-config.1
