#!/bin/bash

gcloud_instances_list() {
    gcloud --format="table[no-heading](name, networkInterfaces[0].accessConfigs[0].natIP,networkInterfaces[0].networkIP)" compute instances list
}

invenotry_json() {
    local meta=""
    local hosts=""
    local group_prefix="reddit-"

    gcloud_instances=$(gcloud_instances_list)

    while read gcloud_instance
    do
        instance=($gcloud_instance)
        name=${instance[0]}
        group=${name#$group_prefix}
        external_ip=${instance[1]}
        internal_ip=${instance[2]}

        printf -v meta '%s, "%s": {"ansible_host": "%s", "internal_ip": "%s"}' "$meta" "${name}-server" "$external_ip" "$internal_ip"
        printf -v hosts '%s, "%s": {"hosts": ["%s"]}' "$hosts" "$group" "${name}-server"
    done <<< "$gcloud_instances"

    printf '{"_meta": {"hostvars": {%s}}, %s}' "${meta:2}" "${hosts:2}"
}

case $@ in
    --list) 
        invenotry_json
        ;;
    --host*) 
        echo '{}' 
        ;;
    *) 
        echo "Unknown option $1" 
        exit 1
        ;;
esac
