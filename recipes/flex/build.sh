./configure --prefix=/usr --disable-static
make
make install
ln -s flex   $DESTDIR/usr/bin/lex
ln -s flex.1 $DESTDIR/usr/share/man/man1/lex.1
