#!/system/bin/sh

scripts=`realpath $0`
scripts_dir=`dirname ${scripts}`
old_local_ipv4=(127.0.0.1)
. /data/Clash/clash.config

monitor_local_ipv4() {
    new_local_ipv4=$(ip a |awk '$1~/inet$/{print $2}')

    for new_subnet in ${new_local_ipv4[*]} ; do
        wait_count=0
        for old_subnet in ${old_local_ipv4[*]} ; do
            if [ "${new_subnet}" != "${old_subnet}" ] ; then
                wait_count=$((${wait_count} + 1))
                if [ wait_count -eq ${#old_local_ipv4[*]} ] ; then
                    echo ${new_subnet}
                fi
            fi
        done

    done

    old_local_ipv4=${new_local_ipv4}
}

keep_dns() {
    local_dns=`getprop net.dns1`

    if [ "${local_dns}" != "${static_dns}" ] ; then
        setprop net.dns1 ${static_dns}
    fi
}

while true ; do
    keep_dns
    sleep 1
done