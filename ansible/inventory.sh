#!/bin/bash

gcloud_instances_list() {
    gcloud --format="table[no-heading](name, networkInterfaces[0].accessConfigs[0].natIP,networkInterfaces[0].networkIP)" compute instances list
}

invenotry_json() {
    local meta=""
    local hosts=""

    gcloud_instances=$(gcloud_instances_list)

    while read gcloud_instance
    do
        instance=($gcloud_instance)
        name=${instance[0]}
        external_ip=${instance[1]}
        internal_ip=${instance[2]}

        printf -v meta '%s, "%s": {"ansible_host": "%s", "internal_ip": "%s"}' "$meta" "${name}-server" "$external_ip" "$internal_ip"

        printf -v hosts '%s, "%s": {"hosts": ["%s"]}' "$hosts" "$name" "${name}-server"
    done <<< "$gcloud_instances"

    printf '{"_meta": {"hostvars": {%s}}, %s}' "${meta:2}" "${hosts:2}"
}

case $@ in
    --list) 
        #cat inventory.json 
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
