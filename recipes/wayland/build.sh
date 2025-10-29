meson setup                  \
      --prefix=/usr          \
      --buildtype=release    \
      -D documentation=false \
      build
meson compile -C build
meson install -C build --destdir $DESTDIR
