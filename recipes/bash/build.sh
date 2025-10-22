./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline
make
make DESTDIR=$DESTDIR install
