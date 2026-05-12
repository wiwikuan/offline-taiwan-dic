#!/bin/bash
# 啟動字典 server（背景常駐，區網可用）

PORT=8765
SERVE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="/tmp/dict-server-${PORT}.log"
PID_FILE="/tmp/dict-server-${PORT}.pid"

# 顏色
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

# 取得區網 IP（過濾掉 127.x、docker、virbr 等虛擬介面）
get_lan_ip() {
    ip -4 addr show scope global 2>/dev/null \
        | grep -oP '(?<=inet\s)\d+(\.\d+){3}' \
        | grep -v '^127\.' \
        | grep -v '^172\.1[7-9]\.' \
        | grep -v '^172\.2[0-9]\.' \
        | grep -v '^172\.3[0-1]\.' \
        | head -n1
}

# 印出可點連結（OSC 8）
print_link() {
    local url="$1"
    local label="${2:-$url}"
    printf '\033]8;;%s\033\\%s\033]8;;\033\\' "$url" "$label"
}

# 檢查是否已經在跑
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    OLD_PID=$(cat "$PID_FILE")
    echo -e "${YELLOW}⚠  server 已經在跑了${RESET}（PID: $OLD_PID）"
    echo
else
    # 檢查 port 有沒有被別人佔用
    if ss -tln 2>/dev/null | grep -q ":${PORT} " || \
       netstat -tln 2>/dev/null | grep -q ":${PORT} "; then
        echo -e "${YELLOW}⚠  port ${PORT} 已被佔用，但不是這個 script 啟動的${RESET}"
        echo "   先處理掉再執行，例如："
        echo "   ${DIM}lsof -i :${PORT}${RESET}"
        exit 1
    fi

    # 啟動
    cd "$SERVE_DIR" || exit 1
    nohup python3 -m http.server "$PORT" --bind 0.0.0.0 \
        > "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"

    # 等一下確認真的起來了
    sleep 0.3
    if ! kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo -e "${YELLOW}✗  啟動失敗，看 log：${RESET} $LOG_FILE"
        rm -f "$PID_FILE"
        exit 1
    fi

    echo -e "${GREEN}✓  server 已啟動${RESET}（PID: $(cat "$PID_FILE")）"
    echo
fi

# 顯示資訊
LAN_IP=$(get_lan_ip)
LOCAL_URL="http://localhost:${PORT}/"

echo -e "${BOLD}服務目錄${RESET}  ${DIM}${SERVE_DIR}${RESET}"
echo -e "${BOLD}log${RESET}        ${DIM}${LOG_FILE}${RESET}"
echo
echo -e "${BOLD}網址${RESET}"
printf '  本機       '
print_link "$LOCAL_URL"
printf '\n'

if [ -n "$LAN_IP" ]; then
    LAN_URL="http://${LAN_IP}:${PORT}/"
    printf '  區網       '
    print_link "$LAN_URL"
    printf '\n'
else
    echo -e "  ${DIM}（找不到區網 IP）${RESET}"
fi

echo
echo -e "${DIM}停止：${RESET} kill \$(cat $PID_FILE)  ${DIM}或${RESET}  pkill -f \"http.server ${PORT}\""
