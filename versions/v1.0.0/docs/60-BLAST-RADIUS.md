> Versi: v1.0.0 | Status: disetujui | Menggantikan: -

# 60-BLAST-RADIUS — titeny-infra-devops

Mengacu: Titeny-TownHall v1.0.0 (https://github.com/Coding-Skuy/Titeny-TownHall/tree/main/versions/v1.0.0).

## Pernyataan read-only

Gelar ini tidak menulis ke DB sumber. Terraform hanya mengelola DB `titeny`; CronJob hanya memicu hitung dan ingest ke API Titeny. Tidak ada user, secret, atau koneksi ke DB Lumbung, TitipO, atau Pasaree di repo ini.

## Radius Dampak per Perubahan

| Perubahan | Dampak | Batas penahan |
|---|---|---|
| Jadwal CronJob | Kesegaran H+1–H+7 ikut berubah | Uji 7 hari sukses job sebelum rilis |
| Terraform DB | Seluruh tulis `titeny` ikut berubah | Rencana + apply bertahap, snapshot dulu |
| Secret | Salah secret mematikan ingest/tayang | Secret per lingkungan, health check pasca-apply |
| Image | Backend + web ikut berubah | Tag image sebelumnya disimpan untuk rollback |

## Larangan Eksplisit

- Dilarang menambah secret atau koneksi ke DB sumber.
- Dilarang menjalankan migrasi tanpa DOWN yang teruji.
- Dilarang commit rahasia (`DATABASE_URL`, token) ke repo.

## Rollback

Setiap rilis menyimpan tag image dan state terraform sebelumnya. Rollback berarti mengembalikan image plus migrasi DOWN, lalu memverifikasi `GET /health` dan satu event duplikat tetap duplikat.

## Batasan

Batasan dokumen ini: hanya radius gelar. Dampak aplikasi ada di repo layanannya masing-masing. Insiden DB sumber diteruskan ke pemilik sumber.
