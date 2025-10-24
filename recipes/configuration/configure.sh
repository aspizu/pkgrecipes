reconfigure() {
    if [[ -f /var/lib/meow/installed/configuration/reconfigure.done ]]; then
        echo "No need to reconfigure."
        exit
    fi
    touch /var/lib/meow/installed/configuration/reconfigure.done
    pwconv
    grpconv
    make-ca -g
}
