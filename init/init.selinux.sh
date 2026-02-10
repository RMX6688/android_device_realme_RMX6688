#!/vendor/bin/sh
#
# Force SELinux into permissive mode as early as possible.
#
# Needed when we cannot rely on our own boot image, e.g. when the kernel is the
# one already on the device (DSU testing), so androidboot.selinux=permissive
# from BOARD_BOOTCONFIG is not present in the kernel command line.
#
# Writing /sys/fs/selinux/enforce needs the `setenforce` check on
# security:security, which AOSP deliberately never allows for normal domains.
# The only sanctioned way around it is to run from a *permissive* domain: a
# denial there is audited instead of enforced, so the write still takes effect.
# See AOSP system/sepolicy/private/su.te:
#     # su is also permissive to permit setenforce.
#     permissive su;
# Our domain is `setenforce_sh`, declared in sepolicy/vendor/setenforce_sh.te.
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

# Belt and braces: this is a no-op if it is denied, and the write above already
# did the job.
setenforce 0 2>/dev/null

if [ "$(enforce_state)" = "0" ]; then
    log "done: SELinux is now permissive (enforce=0)"
    exit 0
fi

log "FAILED: enforce=$(enforce_state) -- check sepolicy/vendor/setenforce_sh.te"
exit 1
