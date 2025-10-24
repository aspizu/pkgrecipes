reconfigure() {

if [[ -f /var/lib/meow/installed/configuration/reconfigure.done ]]; then
    echo "No need to reconfigure."
    exit
fi
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
touch /var/lib/meow/installed/configuration/reconfigure.done
ln -sv /proc/self/mounts /etc/mtab
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
pwconv
grpconv
make-ca -g

}
