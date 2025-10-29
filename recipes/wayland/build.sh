meson setup                  \
      --prefix=/usr          \
      --buildtype=release    \
      -D documentation=false \
      build
meson -C build compile
meson -C build install --destdir $DESTDIR
