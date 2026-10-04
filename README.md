# titeny-infra-devops

Infrastruktur dan DevOps divisi **Titeny (AI Insight)**, org **Coding-Skuy**. Berisi **job terjadwal** dan pengelolaan **secrets**.

Ekosistem: [Titeny-TownHall](https://github.com/Coding-Skuy/Titeny-TownHall).

## Prasyarat (versi dipin)

- Terraform 1.9.8
- Docker 27.3.1
- kubectl 1.31.2 (klaster Kubernetes 1.31)
- GitHub Actions (runner `ubuntu-24.04`)

## Job terjadwal

| Nama | Jadwal | Kerja |
|------|--------|-------|
| `insight-harian` | `0 1 * * *` | tarik ingest, hitung prediksi via `titeny-ai-models`, tulis ke DB `titeny` |
| `harga-per-jam` | `15 * * * *` | perbarui harga dari event `lumbung.harga.perbarui` |

Definisi ada di `k8s/cronjob-insight.yaml` dan `.github/workflows/scheduled-insight.yml`.

## Secrets

Jangan tulis secrets di repo. Daftar yang wajib ada di lingkungan:

- `DATABASE_URL` — koneksi Postgres basis data `titeny`
- `TITENY_API_TOKEN` — token antar layanan backend dan pipa data
- `GHCR_TOKEN` — token dorong citra kontainer

Gunakan `scripts/setup-secrets.sh` untuk memeriksa keberadaannya sebelum deploy.
