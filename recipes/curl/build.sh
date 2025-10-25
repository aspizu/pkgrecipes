./configure --prefix=/usr    \
            --disable-static \
            --with-openssl   \
            --with-ca-path=/etc/ssl/certs
make
make DESTDIR=$DESTDIR install
