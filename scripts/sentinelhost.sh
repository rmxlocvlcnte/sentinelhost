#!/usr/bin/env bash

# FALTA RETOCAR DETALHES

set -euo pipefail
IFS=$'\n\t'

BASE_DIR="/var/log/relatorios"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
REPORT_JSON="$BASE_DIR/report_$TIMESTAMP.json"
LOG_TXT="$BASE_DIR/report_$TIMESTAMP.txt"

LINHAS_MAX_LOG=3000
PORTAS_SUSPEITAS=':(21|22|23|3389|4444|5900)\b' #PORTAS SSH, VNC, TELNET, TCP/UDP, RDP, FTP

mkdir -p "$BASE_DIR"

# LOGS

log() {
	echo "[$TIMESTAMP] $*" | tee -a "$LOG_TXT"
}

escape_json() {
	echo "$1" | sed 's/"/\\"/g'
}

# INIT JSON

init_json() {
	cat <<EOF > "$REPORT_JSON"
{
 "Horário": "$TIMESTAMP",
 "Hostname": "$(hostname)",
 "Data": {
EOF
}

close_json() {
	sed -i '$ s/,$//' "$REPORT_JSON"
	echo "  }" >> "$REPORT_JSON"
	echo "}" >> "$REPORT_JSON"
}

# JSON_BLOCK

json_block() {
	local chave="$1"
	local valor="$2"

	exec 9>>"$REPORT_JSON"
	flock 9

	echo "  \"$chave\": \"$valor\"," >&9

	flock -u 9
	exec 9>&-
}


# Análise de Rede

analise_rede() {
	log "Iniciando análise de rede"

	local interfaces
	interfaces="$(ip -brief addr 2>/dev/null || echo 'N/A')"

	local ports
	ports="$(ss -tulnp 2>/dev/null | grep -E "$PORTAS_SUSPEITAS" || echo 'N/A')"

	json_block "interfaces_redes" "$(escape_json "$interfaces")"
	json_block "portas_suspeitas" "$(escape_json "$ports")"

	log "Análise de Rede completa"
}

# Analisar log

analise_log() {
log "Iniciando análise"

local logins_falhos
logins_falhos="$(journalctl -p err..alert --since "24 horas atrás" 2>/dev/null \
| grep -Ei 'failed|denied|unauthorized' \
| tail -n "$LINHAS_MAX_LOG" || echo 'N/A')"

json_block "logins_falhos" "$(escape_json "$logins_falhos")"

if [ -f /var/log/auth.log ]; then
	local forca_bruta
	forca_bruta="$(grep -i 'senha errada' /var/log/auth.log \
	| awk '{print $(NF-3)}' \
	| sort | uniq -c | sort -nr | head || echo 'N/A')"

json_block "origens" "$(escape_json "$forca_bruta")"
fi

log 'Análise Completa'
}

# Saúde do Sistema

saude_sis() {
log 'Iniciando análise'

json_block "tempo_online" "$(escape_json "$(uptime)")"
json_block "cpu" "$(escape_json "$(cat /proc/loadavg)")"
json_block "memoria" "$(escape_json "$(free -h)")"
json_block "armazenamento" "$(escape_json "$(df -h)")"
json_block "processos" "$(escape_json "$(ps aux --sort=-%mem | head -n 6)")"

log 'Análise Completa'
}

# MAIN

main() {
log 'Iniciando'
init_json

analise_rede &
analise_log &
saude_sis

wait

close_json
log "Processo Completo"
log "Report JSON: $REPORT_JSON"
log "Report TXT: $LOG_TXT"
}

main
