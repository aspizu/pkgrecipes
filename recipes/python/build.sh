./configure --prefix=/usr          \
            --enable-shared        \
            --with-system-expat    \
            --without-static-libpython
make
make DESTDIR=$DESTDIR install
mkdir $DESTDIR/etc
cat > $DESTDIR/etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
ln -s python3 $DESTDIR/usr/bin/python
ln -s pip3 $DESTDIR/usr/bin/pip
ln -s idle3 $DESTDIR/usr/bin/idle
