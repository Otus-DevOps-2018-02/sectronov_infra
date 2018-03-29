#!/bin/bash

set -e

gcloud compute instances create reddit-app \
	 --boot-disk-size=10GB \
	 --image-family reddit-full \
	 --machine-type=g1-small \
	 --tags reddit-app-server \
	 --restart-on-failure \
     --metadata-from-file startup-script=start-reddit-app.sh

gcloud compute firewall-rules create default-reddit-app-server \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=reddit-app-server
  