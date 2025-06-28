#!/bin/bash

# CONFIGURAZIONI
KEY="/local/domain/0/messaging/test"
ITERATIONS=10000
MSG_SIZE=1024
SLEEP_MS=1 # pausa tra invii in ms

echo "DomU-A: invio di $ITERATIONS messaggi da $MSG_SIZE byte..."

# Prepara il messaggio costante
MESSAGE=$(head -c $MSG_SIZE < /dev/zero | tr '\0' 'A')

# Rimuove eventuali chiavi residue
xenstore-rm "$KEY" 2>/dev/null

start_ns=$(date +%s%N)

for ((i=1; i<=ITERATIONS; i++)); do
    xenstore-write "$KEY" "$MESSAGE"
    sleep 0.$(printf "%03d" $SLEEP_MS)
done

end_ns=$(date +%s%N)
duration_ns=$((end_ns - start_ns))
total_bytes=$((ITERATIONS * MSG_SIZE))

# Flusso medio in MB/s
duration_s=$(echo "scale=6; $duration_ns / 1000000000" | bc)
throughput=$(echo "scale=2; $total_bytes / duration_s / (1024*1024)" | bc)

echo "Mittente completato:"
echo "   Durata totale: ${duration_s}s"
echo "   Throughput medio: ${throughput} MB/s"

