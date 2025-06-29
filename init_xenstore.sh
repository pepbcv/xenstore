#!/bin/bash

# === CONFIGURAZIONE ===
DOMU_A_ID=4   # ID della VM mittente (domU A)
DOMU_B_ID=3   # ID della VM ricevente (domU B)

# === INIZIALIZZAZIONE DOMU A ===
sudo xenstore-rm /local/domain/$DOMU_A_ID/data 2>/dev/null
sudo xenstore-write /local/domain/$DOMU_A_ID/data/init ok
sudo xenstore-chmod -r /local/domain/$DOMU_A_ID/data b

# === INIZIALIZZAZIONE DOMU B ===
sudo xenstore-rm /local/domain/$DOMU_B_ID/ready 2>/dev/null
sudo xenstore-write /local/domain/$DOMU_B_ID/ready/init ok
sudo xenstore-chmod -r /local/domain/$DOMU_B_ID/ready b

echo "Inizializzazione Xenstore completata"
