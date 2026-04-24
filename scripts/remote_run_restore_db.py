"""Upload and run scripts/restore_fergana_sqlite_from_legacy.sh on the VPS (SSH).

PowerShell:
  $env:FERGANA_DEPLOY_SSH_PASSWORD = '***'
  python scripts/remote_run_restore_db.py
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

import paramiko


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")

    password = os.environ.get("FERGANA_DEPLOY_SSH_PASSWORD", "").strip()
    if not password and len(sys.argv) > 1:
        password = sys.argv[1].strip()
    if not password:
        print("Set FERGANA_DEPLOY_SSH_PASSWORD.", file=sys.stderr)
        return 2

    host = os.environ.get("FERGANA_DEPLOY_SSH_HOST", "167.71.53.238").strip()
    user = os.environ.get("FERGANA_DEPLOY_SSH_USER", "root").strip()
    script_path = Path(__file__).resolve().parents[1] / "scripts" / "restore_fergana_sqlite_from_legacy.sh"
    body = script_path.read_text(encoding="utf-8")

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(
        hostname=host,
        username=user,
        password=password,
        timeout=30,
        banner_timeout=120,
        auth_timeout=120,
    )
    try:
        sftp = client.open_sftp()
        remote_path = "/tmp/restore_fergana_sqlite_from_legacy.sh"
        with sftp.file(remote_path, "w") as remote:
            remote.write(body)
        sftp.chmod(remote_path, 0o755)
        sftp.close()

        _chan, stdout, stderr = client.exec_command(f"bash {remote_path}", get_pty=True)
        for line in iter(stdout.readline, ""):
            if line:
                sys.stdout.write(line)
        err = stderr.read().decode("utf-8", errors="replace")
        if err.strip():
            sys.stderr.write(err)
        return int(stdout.channel.recv_exit_status())
    finally:
        client.close()


if __name__ == "__main__":
    raise SystemExit(main())
