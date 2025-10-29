mkdir build
cd build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D documentation=false
meson compile ..
meson install .. --destdir $DESTDIR
