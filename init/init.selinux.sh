#!/vendor/bin/sh
#
# Force SELinux into permissive mode at early-init, for boot images that do not
# carry androidboot.selinux=permissive. The domain is permissive so that the
# write to /sys/fs/selinux/enforce is audited instead of denied; see
# sepolicy/vendor/setenforce_sh.te.
#

KMSG=/dev/kmsg
TRIES=10

log() {
    echo "<6>selinux_permissive: $1" > ${KMSG} 2>/dev/null
}

enforce_state() {
    cat /sys/fs/selinux/enforce 2>/dev/null
}

log "start: domain=$(cat /proc/self/attr/current 2>/dev/null) enforce=$(enforce_state)"

# early-init: init may still write enforce once itself, so retry briefly.
i=0
while [ ${i} -lt ${TRIES} ]; do
    echo 0 > /sys/fs/selinux/enforce 2>/dev/null
    [ "$(enforce_state)" = "0" ] && break
    i=$((i + 1))
    sleep 0.1
done

setenforce 0 2>/dev/null

if [ "$(enforce_state)" = "0" ]; then
    log "done: SELinux is now permissive (enforce=0)"
    exit 0
fi

log "FAILED: enforce=$(enforce_state) -- check sepolicy/vendor/setenforce_sh.te"
exit 1
