#!/usr/bin/env bash
# Run as root on the VPS. Restores /opt/fergana-smartcity/repo/backend/db.sqlite3 from the
# legacy Smartcity install or timestamped backups (does not touch other apps' DBs).

set -euo pipefail

DEST_DIR="/opt/fergana-smartcity/repo/backend"
DEST_DB="${DEST_DIR}/db.sqlite3"
VENV="/opt/fergana-smartcity/venv"

require_root() {
  if [[ "${EUID:-0}" -ne 0 ]]; then
    echo "Run as root." >&2
    exit 1
  fi
}

pick_source_db() {
  local c candidates newest f

  # Prefer live legacy DB if it looks real (not empty).
  if [[ -f /var/www/smartcity-backend/db.sqlite3 ]]; then
    c=$(stat -c%s /var/www/smartcity-backend/db.sqlite3 2>/dev/null || echo 0)
    if [[ "${c}" -gt 8192 ]]; then
      echo "/var/www/smartcity-backend/db.sqlite3"
      return 0
    fi
  fi

  if [[ -d /var/backups/smartcity ]]; then
    newest=""
    for f in /var/backups/smartcity/db_*.sqlite3; do
      [[ -f "$f" ]] || continue
      if [[ -z "${newest}" ]] || [[ "$f" -nt "${newest}" ]]; then
        newest="$f"
      fi
    done
    if [[ -n "${newest}" ]]; then
      c=$(stat -c%s "${newest}" 2>/dev/null || echo 0)
      if [[ "${c}" -gt 8192 ]]; then
        echo "${newest}"
        return 0
      fi
    fi
  fi

  if [[ -d /var/www/smartcity-backend/backups ]]; then
    newest=""
    for f in /var/www/smartcity-backend/backups/db_backup_*.sqlite3; do
      [[ -f "$f" ]] || continue
      if [[ -z "${newest}" ]] || [[ "$f" -nt "${newest}" ]]; then
        newest="$f"
      fi
    done
    if [[ -n "${newest}" ]]; then
      c=$(stat -c%s "${newest}" 2>/dev/null || echo 0)
      if [[ "${c}" -gt 8192 ]]; then
        echo "${newest}"
        return 0
      fi
    fi
  fi

  return 1
}

fix_perms() {
  chgrp www-data "${DEST_DIR}" || true
  chmod 2775 "${DEST_DIR}" || true
  chown www-data:www-data "${DEST_DB}" || true
  chmod 664 "${DEST_DB}" || true
}

main() {
  require_root
  mkdir -p "${DEST_DIR}"

  local src
  if ! src="$(pick_source_db)"; then
    echo "No suitable SQLite backup found. Checked:" >&2
    echo "  - /var/www/smartcity-backend/db.sqlite3 (>8KB)" >&2
    echo "  - /var/backups/smartcity/db_*.sqlite3 (newest, >8KB)" >&2
    echo "  - /var/www/smartcity-backend/backups/db_backup_*.sqlite3 (newest, >8KB)" >&2
    exit 2
  fi

  echo "Using source database: ${src} ($(stat -c%s "${src}") bytes)"

  if [[ -f "${DEST_DB}" ]]; then
    mv "${DEST_DB}" "${DEST_DB}.replaced-$(date +%Y%m%d_%H%M%S)"
    echo "Renamed current DB to backup beside new restore."
  fi

  cp -a "${src}" "${DEST_DB}"
  fix_perms

  export DJANGO_SETTINGS_MODULE=smartcity_backend.settings
  cd "${DEST_DIR}"
  # Legacy DB may already contain livestock tables but not record migration 0010.
  if ! "${VENV}/bin/python" manage.py migrate --noinput; then
    echo "migrate had errors; attempting to fake livestock migration if tables already exist..."
    "${VENV}/bin/python" manage.py migrate smartcity_app 0010_livestock_farm_microchip --fake || true
    "${VENV}/bin/python" manage.py migrate --noinput
  fi

  systemctl restart fergana-smartcity-gunicorn.service
  echo "Restore complete. API DB: ${DEST_DB}"
}

main "$@"
