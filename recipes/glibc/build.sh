sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
  __libc_rwlock_define_initialized (, reset_lock);\
  memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c 
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4
make
make DESTDIR=$DESTDIR install
make DESTDIR=$DESTDIR localedata/install-locales
sed '/RTLDLIST=/s@/usr@@g' -i $DESTDIR/usr/bin/ldd
mkdir -p $DESTDIR/etc
cat > $DESTDIR/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
mkdir -p $DESTDIR/etc/ld.so.conf.d
cat > $DESTDIR/etc/ld.so.conf << "EOF"
/usr/local/lib
/opt/lib
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
mkdir $DESTDIR/lib
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $DESTDIR/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $DESTDIR/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $DESTDIR/lib64/ld-lsb-x86-64.so.3
    ;;
esac
