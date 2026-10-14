> Versi: v1.0.0 | Status: disetujui | Menggantikan: -

# 60-BLAST-RADIUS — titeny-infra-devops

Mengacu: Titeny-TownHall v1.0.0 (`https://github.com/Coding-Skuy/Titeny-TownHall/tree/main/platform/versions/v1.0.0`), [`townhall-roadmap.md` bagian 2](https://github.com/Coding-Skuy/ChefGenie-TownHall/blob/main/townhall-roadmap.md) (baris Titeny: point of concern "11 event; MAPE H+1 <= 8%"; batas context "12 komoditas x 8 pasar; read-only ke DB sumber") dan [`KONTEKS-LINTAS-DIVISI.md` bagian 8-9](https://github.com/Coding-Skuy/ChefGenie-TownHall/blob/main/KONTEKS-LINTAS-DIVISI.md).

## Pernyataan read-only

Repo ini tidak menulis ke DB sumber. Titeny hanya membaca dari Lumbung, TitipO, dan Pasaree (lewat event/konektor SELECT); satu-satunya basis tulis adalah DB `titeny`.

## Yang BOLEH disentuh repo ini

Workflow CI, Terraform DB `titeny`, manifes k8s, skrip secrets, runbook, pipeline rilis MSI/image.

## Yang DILARANG

- Membuat user, secret, atau koneksi ke DB Lumbung, TitipO, atau Pasaree dengan hak tulis (kredensial sumber hanya SELECT).
- Meng-commit rahasia (`DATABASE_URL`, kunci JWT, token).
- Menjalankan migrasi tanpa DOWN yang teruji; rilis saat QA gate merah atau melewati test.
- Mengubah jadwal job tanpa seizin analis dan pembaruan TownHall.

## Kontrak

- **Dikonsumsi**: Artefak build dari `titeny-backend-service`, `titeny-web`, `titeny-app-kmp`, `titeny-ai-models`, `titeny-data-pipeline`.
- **Diproduksi**: Lingkungan terdeploy, job terjadwal, rahasia terkelola, artefak rilis (image, MSI + `SHA256SUMS.txt`), runbook rilis/rollback/insiden kunci.
- Modul bersama `:shared:pantry-resep` adalah milik Pawonee dan tidak dipakai atau diubah oleh Titeny. `pedaree.stok.v1` adalah kontrak bilateral Pedaree-TitipO dan bukan bagian registry Titeny (11 event terkunci).

## Radius Dampak per Perubahan

| Perubahan | Dampak | Batas penahan |
|---|---|---|
| Jadwal CronJob | Kesegaran H+1–H+7 ikut berubah | Uji 7 hari sukses job sebelum rilis |
| Terraform DB | Seluruh tulis `titeny` ikut berubah | Rencana + apply bertahap, snapshot dulu |
| Secret | Salah secret mematikan ingest/tayang | Secret per lingkungan, health check pasca-apply |
| Image | Backend + web ikut berubah | Tag image sebelumnya disimpan untuk rollback |

## Rollback

Setiap rilis menyimpan tag image dan state terraform sebelumnya. Rollback berarti mengembalikan image plus migrasi DOWN, lalu memverifikasi `GET /health` dan satu event duplikat tetap duplikat.

## Batasan

Dokumen ini hanya mengatur radius repo `titeny-infra-devops`. Dampak repo lain ada di dokumen blast-radius repo tersebut. Insiden DB sumber diteruskan ke pemilik sumber.
