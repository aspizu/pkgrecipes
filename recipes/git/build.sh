./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3
make
make DESTDIR=$DESTDIR NO_INSTALL_HARDLINKS=1 perllibdir=/usr/lib/perl5/5.42/site_perl install
