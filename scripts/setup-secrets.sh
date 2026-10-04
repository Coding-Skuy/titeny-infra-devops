#!/bin/sh
# Periksa secrets wajib Titeny sebelum deploy. Tidak mencetak isi secrets.
set -eu
gagal=0
for v in DATABASE_URL TITENY_API_TOKEN GHCR_TOKEN; do
  if [ -z "${v:+x}" ] && [ -z "$(printenv "$v" || true)" ]; then
    echo "HILANG: $v"
    gagal=1
  else
    echo "OK: $v terisi"
  fi
done
exit $gagal
