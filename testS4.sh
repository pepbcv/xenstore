#!/bin/bash

DOMID_B=1
BASE_PATH="/local/domain/2/data"
READY_PATH="/local/domain/${DOMID_B}/ready"
NUM_MSG=10
MSG_SIZE=1024

# Attende che il ricevente sia pronto
echo "Attendo ricevente..."
while true; do
    READY=$(sudo xenstore-read "$READY_PATH" 2>/dev/null)
    if [[ "$READY" == "1" ]]; then
        break
    fi
    sleep 0.1
done
echo "Ricevente pronto. Inizio invio..."

start_total=$(date +%s.%N)

for ((i=1; i<=NUM_MSG; i++)); do
    payload="Messaggio numero $i"
    pad=$(printf '%*s' $((MSG_SIZE - ${#payload} - 20)) | tr ' ' 'X')  # 20 per timestamp e separatori
    timestamp=$(date +%s.%N)
    message="$payload|$timestamp|$pad"
    sudo xenstore-write "${BASE_PATH}/msg_${i}" "$message"
    echo "Inviato $i: $payload"
done

end_total=$(date +%s.%N)
durata=$(echo "$end_total - $start_total" | bc)
echo "Invio completato in $durata s"
