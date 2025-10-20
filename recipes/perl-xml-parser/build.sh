perl Makefile.PL INSTALLDIRS=vendor
make
make DESTDIR=$DESTDIR install
