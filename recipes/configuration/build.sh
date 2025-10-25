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
ID=meowOS
PRETTY_NAME="meowOS 12.4"
HOME_URL="https://tilde.club/~aspizu/"
RELEASE_TYPE="stable"
EOF

cat > $DESTDIR/etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

cat > $DESTDIR/etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

cat > $DESTDIR/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF
