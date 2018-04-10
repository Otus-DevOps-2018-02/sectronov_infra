#!/bin/bash

case $@ in
    --list) 
        cat inventory.json 
        ;;
    --host*) 
        echo '{}' 
        ;;
    *) 
        echo "Unknown option $1" 
        exit 1
        ;;
esac
