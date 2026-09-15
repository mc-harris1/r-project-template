#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_name="$(basename "$repo_root")"
default_library="${HOME}/.uvr/projects/${project_name}/library"

if ! command -v uvr >/dev/null 2>&1; then
  printf '%s\n' "uvr is required. Install it from https://github.com/nbafrank/uvr, then rerun this script." >&2
  exit 1
fi

cd "$repo_root"
export UVR_LIBRARY="${UVR_LIBRARY:-$default_library}"

if [[ -f .Rprofile ]]; then
  sed -i.bak \
    -e '/^source("renv\/activate\.R")$/d' \
    -e '/^Sys\.setenv(RENV_CONFIG_SANDBOX_ENABLED = TRUE)$/d' \
    .Rprofile
  rm -f .Rprofile.bak
fi

if [[ ! -f uvr.toml ]]; then
  if [[ ! -f renv.lock ]]; then
    printf '%s\n' "Cannot initialize uvr: neither uvr.toml nor renv.lock exists." >&2
    exit 1
  fi
  uvr import
fi

uvr r install 4.6.1
uvr r pin 4.6.1
if ! grep -Fxq '[dependencies.uvr]' uvr.toml; then
  uvr add 'nbafrank/uvr-r@main' --no-lock
  perl -0pi -e 's/^\[dependencies\.uvr-r\]$/[dependencies.uvr]/m' uvr.toml
fi
uvr lock
uvr sync

perl -0pi -e 's/^Sys\.setenv\(UVR_LIBRARY = .*\)\n\n//m; s/^# >>> uvr >>>$/Sys.setenv(UVR_LIBRARY = "$ENV{UVR_LIBRARY}")\n\n# >>> uvr >>>/m' .Rprofile

rm -rf .uvr/library

printf 'uvr setup complete. Project packages are installed in: %s\n' "$UVR_LIBRARY"
