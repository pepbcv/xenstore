#!/bin/bash

DOMUA_ID=5
DOMUB_ID=6

READY_PATH="/local/domain/$DOMUB_ID/ready"
PREFIX="/local/domain/$DOMUA_ID/data"
NUM_MSG=100
MSG_SIZE=1024
total_latency=0


#Stato iniziale
echo "🧪 Stato prima del test:" > ricevente_metrics.log
free -h >> ricevente_metrics.log
top -b -n1 | grep "Cpu(s)" >> ricevente_metrics.log
echo "-------------------------------" >> ricevente_metrics.log

# Segnala che sei pronto
sudo xenstore-write "$READY_PATH" "ready"
echo "Ricevente pronto."

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

# Stato finale
echo "" >> ricevente_metrics.log
echo "Stato dopo il test:" >> ricevente_metrics.log
free -h >> ricevente_metrics.log
top -b -n1 | grep "Cpu(s)" >> ricevente_metrics.log
echo "Test terminato in ${durata}s" >> ricevente_metrics.log
