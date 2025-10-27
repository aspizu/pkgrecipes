make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
mkdir -p $DESTDIR/usr/include
cp -r usr/include $DESTDIR/usr
