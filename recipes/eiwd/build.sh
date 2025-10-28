./configure               \
    --prefix=/usr         \
    --libexecdir=/usr/bin \
    --localstatedir=/var  \
    --disable-dbus
make
make DESTDIR=$DESTDIR install
