#!/bin/bash

# Legge i 10 messaggi da Xenstore
for i in $(seq 1 10); do
    path="/local/domain/15/data/message$i"
    if sudo xenstore-exists "$path"; then
        value=$(sudo xenstore-read "$path")
        echo "Letto: $value"
        sudo xenstore-rm "$path"
    else
        echo "Chiave $path non trovata"
    fi
    sleep 0.5
done
