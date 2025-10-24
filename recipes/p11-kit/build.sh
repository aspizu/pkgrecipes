sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF
meson setup              \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors \
      _build
meson compile -C _build
meson install -C _build --destdir=$DESTDIR
mkdir -p $DESTDIR/usr/lib
ln -sfv ./pkcs11/p11-kit-trust.so $DESTDIR/usr/lib/libnssckbi.so
