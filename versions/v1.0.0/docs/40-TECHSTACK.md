> Versi: v1.0.0 | Status: disetujui | Menggantikan: -

# 40-TECHSTACK — titeny-infra-devops

Mengacu: Titeny-TownHall v1.0.0 (`https://github.com/Coding-Skuy/Titeny-TownHall/tree/main/platform/versions/v1.0.0`). Stack pengikat divisi: [`FSD/30-kontrak.md`](https://github.com/Coding-Skuy/Titeny-TownHall/blob/main/platform/versions/v1.0.0/FSD/30-kontrak.md).

## Konteks TownHall

Stack divisi dikunci di TownHall v1.0.0: web Bun + Svelte 5 + SvelteKit 2 + TypeScript; analis-desktop KMP Windows (Kotlin, Compose Multiplatform, Navigation3); backend Rust Axum 0.8; model dan pipeline Python 3.12. Repo ini: Infrastruktur Titeny: CI/CD, job terjadwal model/ingest, deploy per lingkungan, pengelolaan secrets, dan rilis (backend/web, MSI desktop analis) tanpa menyentuh DB sumber.

## Stack Repo Ini

| Lapisan | Pilihan | Versi target | STATUS |
|---|---|---|---|
| CI | GitHub Actions, runner `ubuntu-24.04` (+ Windows untuk MSI) | - | defined |
| Orkestrasi | Kubernetes CronJob `k8s/cronjob-insight.yaml` | 1.31; harga 04.00, demand 04.30, panen Senin 03.00, skor MAPE Minggu 23.00 WIB | defined |
| IaC | Terraform, `terraform/main.tf` (DB `titeny`) | 1.9.8 | defined |
| Kontainer | Docker | 27.3.1 | defined |
| Basis data | PostgreSQL `titeny` | 16+ | defined |
| Rahasia | `scripts/setup-secrets.sh` + secret manager | `DATABASE_URL`, kunci JWT, `TITENY_API_TOKEN`, kredensial read-only S1-S10 | defined |
| Rilis desktop | MSI 64-bit via WiX 3.14 | Windows 10 21H2+ / Windows 11 | defined |
| Rilis server | Image `ghcr.io/coding-skuy/titeny-backend-service` + web Bun | tag sebelumnya disimpan | defined |

## Perintah

```bash
./scripts/setup-secrets.sh
terraform -chdir=terraform init
terraform -chdir=terraform apply
kubectl apply -f k8s/cronjob-insight.yaml
```

## Jadwal Job Terkunci (WIB)

| Job | Jadwal | Catatan |
|---|---|---|
| Harga H+1-H+7 | 04.00 (+ hitung ulang 15.00 bila ada koreksi siang) | retry 04.30 dan 05.00, lalu prediksi H-1 berlabel basi |
| Demand H+7/H+30 | 04.30 | - |
| Panen M+1-M+4 | Senin 03.00 | - |
| Skor MAPE mingguan | Minggu 23.00 | - |

Kunci berkas mencegah job ganda; gagal 3x memicu log `pager: true`. Zona waktu kluster wajib diperhitungkan: CronJob memakai `timeZone: Asia/Jakarta`.

## Kewajiban Selaras Kode (migrasi)

`k8s/cronjob-insight.yaml` dan workflow `scheduled-insight.yml` kini memakai `0 1 * * *` dan `15 * * * *` serta event `lumbung.harga.perbarui`; wajib diganti ke jadwal terkunci di atas dan registry 11 event.

## Batasan

Dokumen ini hanya mengatur stack repo `titeny-infra-devops`. Perubahan versi pustaka atau stack dicatat sebagai ADR baru di `docs/decisions/` dan dilaporkan ke TownHall. Titeny read-only terhadap DB sumber; satu-satunya basis tulis adalah DB `titeny`.
