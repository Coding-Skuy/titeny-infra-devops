> Versi: v1.0.0 | Status: disetujui | Menggantikan: -

# 40-TECHSTACK — titeny-infra-devops

Mengacu: Titeny-TownHall v1.0.0 (https://github.com/Coding-Skuy/Titeny-TownHall/tree/main/versions/v1.0.0).

## Konteks TownHall

Stack divisi dikunci di TownHall v1.0.0: web Bun latest + Svelte 5 + SvelteKit Kit 2 + TypeScript latest; analis-desktop KMP Windows; backend Rust axum 0.8.4; model dan pipeline Python 3.12. Repo ini menggelar semuanya tanpa menyentuh DB sumber.

## Stack Repo Ini

| Lapisan | Pilihan | Versi target | STATUS |
|---|---|---|---|
| Orkestrasi | Kubernetes CronJob (`k8s/cronjob-insight.yaml`) | job 04.00/04.30 + Senin 03.00 | defined |
| Basis data | Terraform PostgreSQL (`terraform/main.tf`) database `titeny` | 16+ | defined |
| Rahasia | `scripts/setup-secrets.sh` via secret manager (`DATABASE_URL`, `TITENY_API_TOKEN`) | tidak di-commit | defined |
| Image | `ghcr.io/coding-skuy/titeny-backend-service:0.1.0` + web Bun latest | — | defined |
| Kunci | Satu pool hanya ke DB `titeny`; JWT `aud=titeny` | — | defined |

## Perintah

```bash
./scripts/setup-secrets.sh
terraform -chdir=terraform init
terraform -chdir=terraform apply
kubectl apply -f k8s/cronjob-insight.yaml
```

## Batasan

Batasan dokumen ini: hanya gelar dan rahasia. Dilarang membuat koneksi, user, atau secret ke DB Lumbung/TitipO/Pasaree. Perubahan jadwal job wajib seizin analis karena memengaruhi kesegaran H+1–H+7.
