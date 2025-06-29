#!/bin/bash

BASE_PATH="/local/domain/2/data"
NUM_MSG=10

for i in $(seq 1 $NUM_MSG); do
    MSG=$(sudo xenstore-read "${BASE_PATH}/msg_$i" 2>/dev/null)
    HEADER=$(echo "$MSG" | cut -c1-25) # Mostra solo l’inizio
    echo "Letto: $HEADER"
done
