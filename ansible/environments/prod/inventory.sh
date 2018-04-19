#!/bin/bash

export GCLOUD_ENV_TAG=prod
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../../old/inventory.sh
