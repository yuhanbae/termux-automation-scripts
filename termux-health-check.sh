#!/data/data/com.termux/files/usr/bin/bash
# termux-health-check.sh — one-shot device health report for Termux/Android.
# Usage: bash termux-health-check.sh [--json]
# Every termux-api call is timeout-guarded: those commands can block on an
# Android permission prompt, which would hang the whole report.
set -euo pipefail

JSON=false; [ "${1:-}" = "--json" ] && JSON=true
TA=8   # per-call timeout for termux-api commands

bat="n/a"; plug="n/a"; temp="n/a"; wifi="down"
if command -v termux-battery-status >/dev/null 2>&1; then
  eval "$(timeout $TA termux-battery-status 2>/dev/null | python3 -c '
import json,sys
try: d=json.load(sys.stdin)
except Exception: sys.exit(0)
print("bat=%s" % d.get("percentage","n/a"))
print("plug=%s" % d.get("plugged","n/a"))
print("temp=%s" % d.get("temperature","n/a"))' 2>/dev/null || true)"
fi
if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
  wifi=$(timeout $TA termux-wifi-connectioninfo 2>/dev/null | python3 -c '
import json,sys
try: print(json.load(sys.stdin).get("ssid","down"))
except Exception: print("down")' 2>/dev/null || echo down)
fi
mem=$(awk '/MemAvailable/{printf "%.0fMB", $2/1024}' /proc/meminfo 2>/dev/null || echo n/a)
# Android kernels often lack /proc/loadavg and /proc/uptime — compute from /proc/stat
# and fall back to init (pid 1) elapsed time.
# Android exposes neither /proc/loadavg nor readable /proc/stat — report n/a
# rather than hang or crash; battery/memory/storage carry the report.
if [ -r /proc/loadavg ]; then
  load=$(awk '{print $1}' /proc/loadavg)
else
  load="n/a"
fi
storage=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $4" free / "$2}')
if [ -r /proc/uptime ]; then
  up=$(cut -d. -f1 /proc/uptime)
else
  up=$(ps -o etimes= -p 1 2>/dev/null | tr -d ' ' || echo n/a)
fi

if $JSON; then
  printf '{"battery":"%s","charging":"%s","wifi":"%s","mem":"%s","load":"%s","storage":"%s","uptime_s":"%s"}\n' \
    "$bat" "$plug" "$wifi" "$mem" "$load" "$storage" "$up"
else
  echo "===== Termux Health Check $(date -u +%FT%TZ) ====="
  printf '%-16s %s\n' Battery: "${bat}% (${plug}, ${temp}C)"
  printf '%-16s %s\n' WiFi: "$wifi"
  printf '%-16s %s\n' "Mem available:" "$mem"
  printf '%-16s %s\n' Load: "$load"
  printf '%-16s %s\n' Storage: "$storage"
  printf '%-16s %s\n' "Uptime (s):" "$up"
fi
