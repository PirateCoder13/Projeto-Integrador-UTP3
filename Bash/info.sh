#!/bin/bash

# Encontra o processo do servidor
MC_PID=$(pidof java)

if [ -z "$MC_PID" ]; then
  echo '{"error": "Servidor não está rodando"}' > /var/www/mc-stats.json
  exit 1
fi

# Coleta dados do sistema
CPU_USAGE=$(ps -p $MC_PID -o %cpu --no-headers)
MEM_USAGE=$(ps -p $MC_PID -o %mem --no-headers)
RAM_MB=$(ps -p $MC_PID -o rss --no-headers | awk '{printf "%.1f", $1/1024}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
HDD_SPACE=$(df -h / | awk 'NR==2 {print $4}')

# Gera JSON
echo "{
  \"cpu\": \"$CPU_USAGE%\",
  \"memory\": \"$MEM_USAGE%\",
  \"ram_mb\": \"$RAM_MB MB\",
  \"disk_usage\": \"$DISK_USAGE%\",
  \"hdd_free\": \"$HDD_SPACE\"
}" > /var/www/mc-stats.json
