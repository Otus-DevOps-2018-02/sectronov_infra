#!/bin/bash

gcloud_instances_env_filter="tags.items=${GCLOUD_ENV_TAG:?Please set GCLOUD_ENV_TAG to stage or prod}"

gcloud_instances_list() {
    gcloud --format="table[no-heading](name, networkInterfaces[0].accessConfigs[0].natIP,networkInterfaces[0].networkIP)" compute instances list -q --filter="${gcloud_instances_env_filter}"
}

invenotry_json() {
    local meta=""
    local hosts=""
    local group_prefix="reddit-"

    gcloud_instances=$(gcloud_instances_list)

    while read gcloud_instance
    do
        [[ -z "$gcloud_instance" ]] && continue

        instance=($gcloud_instance)
        name=${instance[0]}
        group=${name#$group_prefix}
        external_ip=${instance[1]}
        internal_ip=${instance[2]}

        printf -v meta '%s, "%s": {"ansible_host": "%s", "internal_ip": "%s"}' "$meta" "${name}-server" "$external_ip" "$internal_ip"
        printf -v hosts '%s, "%s": {"hosts": ["%s"]}' "$hosts" "$group" "${name}-server"
    done <<< "$gcloud_instances"

    if [[ -z "$meta" ]]
    then
        echo '{}'
    else
        printf '{"_meta": {"hostvars": {%s}}, %s}' "${meta:2}" "${hosts:2}"
    fi
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
