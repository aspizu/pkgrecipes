sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in
sed -i '/systemd-sysctl/s/^/#/' rules.d/99-systemd.rules.in
sed -e '/NETWORK_DIRS/s/systemd/udev/' \
    -i src/libsystemd/sd-network/network-util.h
mkdir -p build
cd       build
meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D mode=release           \
      -D dev-kvm-mode=0660      \
      -D link-udev-shared=false \
      -D logind=false           \
      -D vconsole=false
export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
                      awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')
ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
      $(realpath libudev.so --relative-to .)                         \
      $udev_helpers
install -vm755 -d $DESTDIR/usr/{bin,sbin,include}
install -vm755 -d $DESTDIR{/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
install -vm755 -d $DESTDIR/usr/{lib,share}/pkgconfig
install -vm755 udevadm                             $DESTDIR/usr/bin/
install -vm755 systemd-hwdb                        $DESTDIR/usr/bin/udev-hwdb
ln      -svfn  ../bin/udevadm                      $DESTDIR/usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}                 $DESTDIR/usr/lib/
install -vm644 ../src/libudev/libudev.h            $DESTDIR/usr/include/
install -vm644 src/libudev/*.pc                    $DESTDIR/usr/lib/pkgconfig/
install -vm644 src/udev/*.pc                       $DESTDIR/usr/share/pkgconfig/
install -vm644 ../src/udev/udev.conf               $DESTDIR/etc/udev/
install -vm644 rules.d/* ../rules.d/README         $DESTDIR/usr/lib/udev/rules.d/
install -vm644 $(find ../rules.d/*.rules \
                      -not -name '*power-switch*') $DESTDIR/usr/lib/udev/rules.d/
install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} $DESTDIR/usr/lib/udev/hwdb.d/
install -vm755 $udev_helpers                       $DESTDIR/usr/lib/udev
install -vm644 ../network/99-default.link          $DESTDIR/usr/lib/udev/network
