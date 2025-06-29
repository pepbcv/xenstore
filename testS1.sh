#!/bin/bash

# Invia 10 messaggi semplici a Xenstore, numerati
for i in $(seq 1 10); do
    message="Messaggio numero $i"
    echo "Scrivo: $message"
    sudo xenstore-write /local/domain/15/data/message$i "$message"
    sleep 0.5
done
