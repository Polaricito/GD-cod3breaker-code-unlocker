#!/usr/bin/env bash

set -e

# Prefer python3 if available
PYTHON_CMD=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON_CMD=python
fi

install_python() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y python3
    PYTHON_CMD=python3
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y python3
    PYTHON_CMD=python3
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y python3
    PYTHON_CMD=python3
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm python
    PYTHON_CMD=python
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y python3
    PYTHON_CMD=python3
  elif command -v rpm >/dev/null 2>&1; then
    RPM_PKGS=(python3*.rpm)
    if [ ${#RPM_PKGS[@]} -gt 0 ] && [ -f "${RPM_PKGS[0]}" ]; then
      sudo rpm -Uvh "${RPM_PKGS[0]}"
      PYTHON_CMD=python3
    else
      echo "RPM package manager detected, but no local Python 3 RPM package found. Please install Python 3 manually." >&2
      exit 1
    fi
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add python3
    PYTHON_CMD=python3
  else
    echo "No supported package manager found to install Python." >&2
    exit 1
  fi
}

if [ -z "$PYTHON_CMD" ]; then
  echo "Python not found, installing..."
  install_python
fi

exec "$PYTHON_CMD" gd.py
