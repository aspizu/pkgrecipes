sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=$DESTDIR/usr install
mkdir -p $DESTDIR/usr/{bin,lib}
cp -av libbz2.so.* $DESTDIR/usr/lib
ln -sv libbz2.so.1.0.8 $DESTDIR/usr/lib/libbz2.so
cp -v bzip2-shared $DESTDIR/usr/bin/bzip2
for i in $DESTDIR/usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv $DESTDIR/usr/lib/libbz2.a
