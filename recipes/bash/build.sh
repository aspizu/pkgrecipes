./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline
make
make install-strip
