./configure               \
    --prefix=/usr         \
    --libexecdir=/usr/bin \
    --localstatedir=/var  \
    --disable-dbus
make
make DESTDIR=$DESTDIR install
install -Dm644 $RECIPE/daemon $DESTDIR/etc/init.d/iwd
