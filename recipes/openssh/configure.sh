install() {
    if ! getent group sshd >/dev/null; then
        groupadd -g 50 sshd
    fi
    if ! id sshd >/dev/null 2>&1; then
        useradd  -c 'sshd PrivSep' \
            -d /var/lib/sshd       \
            -g sshd                \
            -s /bin/false          \
            -u 50 sshd
    fi
    install -v -g sys -m700 -d /var/lib/sshd
}
