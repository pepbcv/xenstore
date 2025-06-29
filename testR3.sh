#!/bin/bash

PREFIX="/local/domain/2/data"
NUM_MSG=10
MSG_SIZE=1024
total_latency=0

start_total=$(date +%s.%N)

for ((i=1; i<=NUM_MSG; i++)); do
    while true; do
        raw=$(sudo xenstore-read "${PREFIX}/msg_${i}" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            recv_time=$(date +%s.%N)
            sent_time=$(echo "$raw" | cut -d'|' -f2)
            latency=$(echo "$recv_time - $sent_time" | bc)
            total_latency=$(echo "$total_latency + $latency" | bc)
            echo "Letto: $(echo "$raw" | cut -d'|' -f1)"
            break
        fi
        sleep 0.01
    done
done

end_total=$(date +%s.%N)
durata=$(echo "$end_total - $start_total" | bc)
media_latency=$(echo "$total_latency / $NUM_MSG" | bc -l)
throughput=$(echo "($NUM_MSG * $MSG_SIZE) / $durata / 1024 / 1024" | bc -l)

echo ""
echo "Ricevitore completato."
echo "Durata totale: ${durata}s"
echo "Latenza media: ${media_latency}s"
echo "Throughput medio: ${throughput} MB/s"
