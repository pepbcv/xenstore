#!/bin/bash

KEY="/local/domain/0/messaging/test"
ITERATIONS=1000
MESSAGE=$(head -c 1024 < /dev/zero | tr '\0' 'A')

echo "DomU-A: invio di $ITERATIONS messaggi da 1024 byte..."

for ((i=1; i<=ITERATIONS; i++)); do
    xenstore-write "$KEY" "$MESSAGE"
    sleep 0.001
done

echo "DomuA: invio completato."
