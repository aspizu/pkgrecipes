mkdir -pv "$DESTDIR"/{etc,var} "$DESTDIR"/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i "$DESTDIR"/$i
done

case $(uname -m) in
  x86_64) mkdir -pv "$DESTDIR"/lib64 ;;
esac

mkdir -pv "$DESTDIR"/tools

# These steps can be done earlier:

# 7.2 Virtual kernel file systems
mkdir -pv "$DESTDIR"/{dev,proc,sys,run}

# 7.5 creating directories

mkdir -pv "$DESTDIR"/{boot,home,mnt,opt,srv}

mkdir -pv "$DESTDIR"/etc/{opt,sysconfig}
mkdir -pv "$DESTDIR"/lib/firmware
mkdir -pv "$DESTDIR"/media/{floppy,cdrom}
mkdir -pv "$DESTDIR"/usr/{,local/}{include,src}
mkdir -pv "$DESTDIR"/usr/lib/locale
mkdir -pv "$DESTDIR"/usr/local/{bin,lib,sbin}
mkdir -pv "$DESTDIR"/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv "$DESTDIR"/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv "$DESTDIR"/usr/{,local/}share/man/man{1..8}
mkdir -pv "$DESTDIR"/var/{cache,local,log,mail,opt,spool}
mkdir -pv "$DESTDIR"/var/lib/{color,misc,locate}

ln -sfv /run "$DESTDIR"/var/run
ln -sfv /run/lock "$DESTDIR"/var/lock

install -dv -m 0750 "$DESTDIR"/root
install -dv -m 1777 "$DESTDIR"/tmp "$DESTDIR"/var/tmp

cat > $DESTDIR/etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  export LANG=en_US.UTF-8
fi

# End /etc/profile
EOF

cat > $DESTDIR/etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

cat > $DESTDIR/etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

echo 12.4 > $DESTDIR/etc/lfs-release

cat > $DESTDIR/etc/lsb-release << "EOF"
DISTRIB_ID="meowOS"
DISTRIB_RELEASE="12.4"
DISTRIB_DESCRIPTION="meowOS"
EOF

cat > $DESTDIR/etc/os-release << "EOF"
NAME="meowOS"
VERSION="12.4"
ID=lfs
PRETTY_NAME="meowOS 12.4"
HOME_URL="https://tilde.club/~aspizu/"
RELEASE_TYPE="stable"
EOF
