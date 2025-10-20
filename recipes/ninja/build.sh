python3 configure.py --bootstrap
install -Dm755 ninja $DESTDIR/usr/bin/ninja
install -Dm644 misc/bash-completion $DESTDIR/usr/share/bash-completion/completions/ninja
install -Dm644 misc/zsh-completion  $DESTDIR/usr/share/zsh/site-functions/_ninja
