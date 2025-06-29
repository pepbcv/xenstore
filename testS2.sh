#!/bin/bash

DOMID=2
BASE_PATH="/local/domain/${DOMID}/data"
NUM_MSG=10

for i in $(seq 1 $NUM_MSG); do
    # Crea un messaggio di 1024 byte: "Messaggio numero X" + padding
    HEADER="Messaggio numero $i"
    PAD=$(printf 'X%.0s' $(seq 1 $((1024 - ${#HEADER}))))
    MESSAGE="${HEADER}${PAD}"

    echo "Scrivo: $HEADER"
    sudo xenstore-write "${BASE_PATH}/msg_$i" "$MESSAGE"
    sleep 0.2
done
