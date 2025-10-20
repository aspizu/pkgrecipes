case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir build
cd build
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
make
make install
ln -sr /usr/bin/cpp $DESTDIR/usr/lib
ln -s gcc $DESTDIR/usr/bin/cc
ln -s gcc.1 $DESTDIR/usr/share/man/man1/cc.1
ln -sf ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        $DESTDIR/usr/lib/bfd-plugins/
mkdir -pv $DESTDIR/usr/share/gdb/auto-load/usr/lib
mv -v $DESTDIR/usr/lib/*gdb.py $DESTDIR/usr/share/gdb/auto-load/usr/lib
