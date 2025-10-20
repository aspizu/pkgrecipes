sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make DESTDIR=$DESTDIR install
ln -sv gawk.1 $DESTDIR/usr/share/man/man1/awk.1
