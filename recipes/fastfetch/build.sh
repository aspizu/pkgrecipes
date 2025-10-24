mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D BUILD_FLASHFETCH=OFF      \
      ..
make
make DESTDIR=$DESTDIR install
