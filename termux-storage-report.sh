#!/data/data/com.termux/files/usr/bin/bash
# termux-storage-report.sh — where did my space go? Top dirs + biggest files.
# Usage: bash termux-storage-report.sh [top_N]
set -euo pipefail
N="${1:-15}"
root="${HOME}"
echo "== $root: $(du -sh "$root" 2>/dev/null | cut -f1) total"
echo "== filesystems =="
df -h "$root" | tail -n +2
echo "== top $N directories =="
du -h --max-depth=1 "$root" 2>/dev/null | sort -rh | head -n "$N"
echo "== top $N files =="
find "$root" -type f -size +1M -printf '%s %p\n' 2>/dev/null | sort -rn | head -n "$N" | \
  while read -r sz path; do printf '%8.1f MB  %s\n' "$(echo "$sz/1048576" | bc -l)" "$path"; done
