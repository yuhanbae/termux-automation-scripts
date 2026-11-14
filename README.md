# Termux Automation Scripts

Working shell scripts for **Termux on Android** — health checks, backups, Wi-Fi
reports, log rotation, clipboard history, boot auto-start, and more.

Every script here is tested: syntax-verified with `bash -n` and executed on a
real device (Termux / Android 16 / aarch64). No stubs, no truncated snippets.

## Included free samples

| Script | What it does |
|---|---|
| [`termux-health-check.sh`](termux-health-check.sh) | Battery, Wi-Fi, memory, storage, uptime in one report. `--json` mode. |
| [`termux-storage-report.sh`](termux-storage-report.sh) | "Where did my space go?" — filesystem usage, top directories, top files. |

## Usage

```bash
pkg install termux-api   # for battery/WiFi/clipboard/torch features (optional)
bash termux-health-check.sh
bash termux-health-check.sh --json
bash termux-storage-report.sh 15
```

Both scripts run on stock Termux with zero dependencies beyond coreutils and
degrade gracefully when `termux-api` is absent.

## Full toolkit

The complete bundle contains **12 working scripts**, including:

- `termux-backup.sh` — full `$HOME` backup with manifest + rotation
- `termux-wifi-report.sh` — nearby APs sorted by signal, `--open` flags unencrypted
- `termux-log-rotate.sh` — size-triggered log rotation with retention
- `termux-clip.sh` — clipboard manager with local history
- `termux-torch.sh` — flashlight with auto-off timer
- `termux-net-speed.sh` — download-speed probe (curl + byte math)
- `termux-json-pretty.sh` — JSON validate/pretty-print/minify from stdin or clipboard
- `termux-cron-helper.sh` — safe crontab add/list/remove
- `termux-boot-setup.sh` — auto-start any script on device boot
- `termux-pkg-audit.sh` — installed/upgradable package audit

**Get the full bundle:** https://yuhanbreeze.gumroad.com/l/ejubwq

## Notes

- Wi-Fi/location results need Android location permission for Termux:API.
- Everything runs locally; no telemetry.
- Review scripts before granting them access to sensitive data.

## License

Sample scripts: MIT. Full bundle: see the Gumroad page.