#!/bin/bash

# ID di domuB (da cui legge)
DOMUB_ID=6

# Chiave da leggere
KEY="/local/domain/$DOMUB_ID/ready"

# Atteso
ATTESO="okkk"

# Lettura
valore=$(sudo xenstore-read "$KEY" 2>/dev/null)

if [[ "$valore" == "$ATTESO" ]]; then
    echo "Ricevuto OK"
else
    echo "Valore inatteso o assente: '$valore'"
fi
