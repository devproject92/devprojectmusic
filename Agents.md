# Agents.md

## Proyek

Aplikasi Flutter `music`. Kode di `lib/`, tes di `test/`, dokumen di `README.md`.

## Perintah penting

- `flutter pub get`
- `flutter analyze` dan `flutter test` — keduanya harus lolos sebelum commit
- `flutter build web --release` untuk pratinjau web
- `flutter build apk --debug` / `--release` untuk Android

## Siklus proses

- Jalankan server/proses panjang di sesi persisten (mis. tmux), jangan di
  perintah berbatas waktu tanpa pelepasan dan pembersihan yang jelas.
- Setelah timeout, periksa dulu proses dan endpoint-nya sebelum mengulang
  atau menyatakan gagal.

## Pratinjau web

- `./startup.sh` memasang Flutter SDK bila belum ada dan mengaktifkan web.
- `./start.sh` membangun `build/web` (hanya bila perlu) lalu menyajikan
  direktori itu di `PORT` (default 3000, bind `0.0.0.0`).
- `./capture.sh` mengambil tangkapan layar; butuh `CAPTURE_URL`, `CAPTURE_DIR`,
  dan `RUNTIME_DIR`. Tunggu kanvas Flutter benar-benar ter-render sebelum
  menangkap, dan buang gambar yang masih memuat atau kosong.
