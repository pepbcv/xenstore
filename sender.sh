#!/bin/bash

# Configurazione
MY_DOMID=15
KEY="/local/domain/$MY_DOMID/msg"
ITER=1000

echo "DomuA: scrivo $ITER messaggi da 1024 byte nella chiave $KEY"

for i in $(seq 1 $ITER); do
  # Parte identificativa del messaggio
  HEAD="msg-$i-$(date +%s%N)"
  
  # Calcola quanti padding byte servono per arrivare a 1024
  PADDING=$(printf "X%.0s" $(seq 1 $((1024 - ${#HEAD}))))
  
  # Componi il messaggio finale
  MSG="${HEAD}${PADDING}"

  # Scrivi su xenstore
  echo "$MSG" | xenstore-write "$KEY"
done

echo "Scrittura completata."
