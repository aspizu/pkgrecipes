./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-history    \
            --with-icu        \
            PYTHON=/usr/bin/python3
make
make DESTDIR=$DESTDIR install
rm $DESTDIR/usr/lib/libxml2.la
sed '/libs=/s/xml2.*/xml2"/' -i $DESTDIR/usr/bin/xml2-config
