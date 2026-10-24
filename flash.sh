#!/bin/bash
# 用 115200 波特率刷机（west flash 默认 921600 在 CH340/CP2102 上会失败）
# 用法: ./flash.sh [端口]   默认端口 /dev/cu.usbserial-130
set -e
cd ~/zephyr/oskey-ws/oskey
source ~/.cargo/env 2>/dev/null
source ~/zephyr/.venv/bin/activate
source ~/zephyr/oskey-ws/zephyr/zephyr-env.sh
source /Users/kayn/export-esp.sh 2>/dev/null

PORT=${1:-$(ls /dev/cu.usbserial-* 2>/dev/null | head -1)}
BAUD=${2:-115200}
echo "刷入端口: $PORT  @${BAUD} baud"
esptool --chip esp32 --port "$PORT" --baud "$BAUD" \
  --before default-reset --after hard-reset write-flash \
  -u --flash-mode dio --flash-freq 40m --flash-size 4MB \
  0x1000 build/oskey/zephyr/zephyr.bin
