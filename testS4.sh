#!/bin/bash

PREFIX="/local/domain/2/data"
NUM_MSG=10
MSG_SIZE=1024

# Attende che il ricevente sia pronto
echo "Attendo ricevente..."
while true; do
    READY=$(sudo xenstore-read "$READY_PATH" 2>/dev/null)
    if [[ "$READY" == "1" ]]; then
        break
    fi
    sleep 1
done
echo "Ricevente pronto. Inizio invio..."


start_total=$(date +%s.%N)

for ((i=1; i<=NUM_MSG; i++)); do
    # Crea messaggio da 1024 byte
    payload="Messaggio numero $i"
    pad=$(printf '%*s' $((MSG_SIZE - ${#payload} - 20)) | tr ' ' 'X')  # 20 per timestamp
    timestamp=$(date +%s.%N)
    message="$payload|$timestamp|$pad"

    echo "Scrivo: $payload"
    sudo xenstore-write "${PREFIX}/msg_${i}" "$message"
done

end_total=$(date +%s.%N)
durata=$(echo "$end_total - $start_total" | bc)
echo "Mittente completato."
echo "Durata totale: ${durata}s"
