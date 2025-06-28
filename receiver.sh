#!/bin/bash

# Configurazione
SENDER_DOMID=15
KEY="/local/domain/$SENDER_DOMID/msg"
ITER=1000
MSG_SIZE=1024  # byte attesi per ogni messaggio

echo "📥 DomU-B: leggo $ITER messaggi da $KEY"

total_ns=0
invalid_count=0

for i in $(seq 1 $ITER); do
  t_start=$(date +%s%N)

  MSG=$(xenstore-read "$KEY")

  t_end=$(date +%s%N)
  delta=$((t_end - t_start))
  total_ns=$((total_ns + delta))

  # Verifica lunghezza messaggio
  actual_size=$(echo -n "$MSG" | wc -c)
  if [ "$actual_size" -ne "$MSG_SIZE" ]; then
    echo "⚠️  Messaggio $i con dimensione anomala: $actual_size byte"
    invalid_count=$((invalid_count + 1))
  fi
done

# Calcola statistiche
avg_ns=$((total_ns / ITER))
avg_ms=$(echo "scale=3; $avg_ns / 1000000" | bc)

# Calcolo throughput
total_bytes=$((ITER * MSG_SIZE))
total_sec=$(echo "scale=6; $total_ns / 1000000000" | bc)
throughput=$(echo "scale=2; $total_bytes / $total_sec" | bc)

# Risultati finali
echo "RISULTATI"
echo "Latenza media: $avg_ns ns (${avg_ms} ms)"
echo "Throughput: $throughput byte/sec"
echo "Messaggi fuori misura: $invalid_count"
