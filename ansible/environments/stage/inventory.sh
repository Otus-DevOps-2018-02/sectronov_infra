#!/bin/bash

export GCLOUD_ENV_TAG=stage
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../../old/inventory.sh
