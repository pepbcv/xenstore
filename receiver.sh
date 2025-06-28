#!/bin/bash

# CONFIGURAZIONI
KEY="/local/domain/0/messaging/test"
ITERATIONS=10000
MSG_SIZE=1024
SLEEP_MS=1

echo "DomU-B: lettura di $ITERATIONS messaggi..."

total_latency_ns=0
invalid_count=0

for ((i=1; i<=ITERATIONS; i++)); do
    start_ns=$(date +%s%N)
    MESSAGE=$(xenstore-read "$KEY")
    end_ns=$(date +%s%N)

    delta_ns=$((end_ns - start_ns))
    total_latency_ns=$((total_latency_ns + delta_ns))

    actual_size=$(echo -n "$MESSAGE" | wc -c)
    if [ "$actual_size" -ne "$MSG_SIZE" ]; then
        echo "⚠️ Messaggio $i: dimensione $actual_size byte (anziché $MSG_SIZE)"
        invalid_count=$((invalid_count + 1))
    fi

    sleep 0.$(printf "%03d" $SLEEP_MS)
done

# Calcoli finali
avg_latency_ns=$((total_latency_ns / ITERATIONS))
avg_latency_ms=$(echo "scale=3; $avg_latency_ns / 1000000" | bc)

echo "Ricevente completato:"
echo "   Latenza media: $avg_latency_ns ns (${avg_latency_ms} ms)"
echo "   Messaggi fuori taglia: $invalid_count/$ITERATIONS"

