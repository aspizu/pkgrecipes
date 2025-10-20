sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns
make DESTDIR=$DESTDIR SBINDIR=/usr/sbin install
