#!/usr/bin/env bash
# Run as root on the VPS. Installs only this app under /opt/fergana-smartcity,
# enables two new nginx site files, and a dedicated systemd unit on port 8020.
# Does not modify existing Smartcity/gunicorn on 8000 or unrelated site configs.

set -euo pipefail

REPO_URL="${FERGANA_REPO_URL:-https://github.com/aiziyrak-coder/fergana.git}"
GIT_BRANCH="${GIT_BRANCH:-master}"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-admin@ziyrak.org}"
BASE="/opt/fergana-smartcity"
REPO="${BASE}/repo"
VENV="${BASE}/venv"

export DEBIAN_FRONTEND=noninteractive

require_root() {
  if [[ "${EUID:-0}" -ne 0 ]]; then
    echo "Run as root." >&2
    exit 1
  fi
}

ensure_dirs() {
  mkdir -p /var/www/certbot/.well-known/acme-challenge
  chmod -R a+rX /var/www/certbot || true
  mkdir -p /var/www/fergana.ziyrak.org
  mkdir -p "${BASE}"
}

ensure_node() {
  if ! command -v node >/dev/null 2>&1; then
    apt-get update -qq
    apt-get install -y -qq ca-certificates curl
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y -qq nodejs
  fi
  local major
  major="$(node -p "Number(process.versions.node.split('.')[0])" 2>/dev/null || echo 0)"
  if [[ "${major}" -lt 18 ]]; then
    echo "Node.js 18+ required for Vite 5. Current: $(node -v 2>/dev/null || echo none)" >&2
    exit 1
  fi
}

ensure_certbot() {
  if ! command -v certbot >/dev/null 2>&1; then
    apt-get update -qq
    apt-get install -y -qq certbot
  fi
}

clone_or_update_repo() {
  if [[ ! -d "${REPO}/.git" ]]; then
    rm -rf "${REPO}" 2>/dev/null || true
    if ! git clone --branch "${GIT_BRANCH}" --depth 1 "${REPO_URL}" "${REPO}"; then
      git clone --depth 1 "${REPO_URL}" "${REPO}"
    fi
  fi

  cd "${REPO}"
  git remote set-url origin "${REPO_URL}" || true
  git fetch origin --prune
  if git show-ref --verify --quiet "refs/remotes/origin/${GIT_BRANCH}"; then
    git checkout "${GIT_BRANCH}"
    git pull --ff-only origin "${GIT_BRANCH}"
  elif git show-ref --verify --quiet "refs/remotes/origin/main"; then
    GIT_BRANCH="main"
    git checkout main
    git pull --ff-only origin main
  else
    git checkout "${GIT_BRANCH}" || git checkout -
    git pull --ff-only || true
  fi
}

setup_python() {
  apt-get update -qq
  apt-get install -y -qq python3-venv python3-pip git nginx

  python3 -m venv "${VENV}"
  # shellcheck source=/dev/null
  source "${VENV}/bin/activate"
  pip install --upgrade pip wheel
  pip install -r "${REPO}/backend/requirements.txt"

  cd "${REPO}/backend"
  export DJANGO_SETTINGS_MODULE=smartcity_backend.settings
  python manage.py migrate --noinput
  python manage.py fix_fergana_user
  python manage.py collectstatic --noinput

  mkdir -p "${REPO}/backend/media"
  # SQLite needs the DB directory writable by Gunicorn (www-data) for WAL/SHM files.
  chgrp www-data "${REPO}/backend" || true
  chmod 2775 "${REPO}/backend" || true
  if [[ -f "${REPO}/backend/db.sqlite3" ]]; then
    chown www-data:www-data "${REPO}/backend/db.sqlite3" || true
    chmod 664 "${REPO}/backend/db.sqlite3" || true
  fi
  chown -R www-data:www-data "${REPO}/backend/media" "${REPO}/backend/static" || true
  chmod -R a+rX "${REPO}/backend" || true
}

setup_gunicorn_unit() {
  install -m0644 "${REPO}/deploy/ziyrak/fergana-smartcity-gunicorn.service" \
    /etc/systemd/system/fergana-smartcity-gunicorn.service
  systemctl daemon-reload
  systemctl enable fergana-smartcity-gunicorn.service
  systemctl restart fergana-smartcity-gunicorn.service
}

build_frontend() {
  cd "${REPO}/frontend"
  if [[ -f .env.production.example ]] && [[ ! -f .env.production ]]; then
    cp .env.production.example .env.production
  fi
  if [[ -f package-lock.json ]]; then
    npm ci
  else
    npm install
  fi
  npm run build
  rm -rf /var/www/fergana.ziyrak.org/*
  cp -a "${REPO}/frontend/dist/." /var/www/fergana.ziyrak.org/
  chown -R www-data:www-data /var/www/fergana.ziyrak.org || true
}

install_nginx_http() {
  install -m0644 "${REPO}/deploy/ziyrak/fergana.ziyrak.org.http.conf" \
    /etc/nginx/sites-available/fergana.ziyrak.org
  install -m0644 "${REPO}/deploy/ziyrak/ferganaapi.ziyrak.org.http.conf" \
    /etc/nginx/sites-available/ferganaapi.ziyrak.org
  ln -sf /etc/nginx/sites-available/fergana.ziyrak.org /etc/nginx/sites-enabled/fergana.ziyrak.org
  ln -sf /etc/nginx/sites-available/ferganaapi.ziyrak.org /etc/nginx/sites-enabled/ferganaapi.ziyrak.org
  nginx -t
  systemctl reload nginx
}

issue_certificates() {
  ensure_certbot
  certbot certonly --webroot -w /var/www/certbot \
    -d fergana.ziyrak.org -d ferganaapi.ziyrak.org \
    --agree-tos --no-eff-email --non-interactive \
    -m "${CERTBOT_EMAIL}" \
    --keep-until-expiring || true
}

install_nginx_ssl_if_ready() {
  if [[ -f /etc/letsencrypt/live/fergana.ziyrak.org/fullchain.pem ]]; then
    install -m0644 "${REPO}/deploy/ziyrak/fergana.ziyrak.org.ssl.conf" \
      /etc/nginx/sites-available/fergana.ziyrak.org
    install -m0644 "${REPO}/deploy/ziyrak/ferganaapi.ziyrak.org.ssl.conf" \
      /etc/nginx/sites-available/ferganaapi.ziyrak.org
    nginx -t
    systemctl reload nginx
  else
    echo "Certbot did not create /etc/letsencrypt/live/fergana.ziyrak.org/ yet. Check DNS A/AAAA for both hosts to 167.71.53.238, then re-run this script." >&2
  fi
}

main() {
  require_root
  ensure_dirs
  ensure_node
  clone_or_update_repo
  setup_python
  setup_gunicorn_unit
  build_frontend
  install_nginx_http
  issue_certificates
  install_nginx_ssl_if_ready
  echo "Done. Frontend: https://fergana.ziyrak.org  API: https://ferganaapi.ziyrak.org"
}

main "$@"
