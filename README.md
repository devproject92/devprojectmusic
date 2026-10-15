# devprojectmusic

<!-- omgithub:readme:start -->
## 🚀 Build, play, and remix with OMGithub

**Remixed using [OMGithub.com](https://omgithub.com).**

[![OMGithub](https://img.shields.io/badge/OMGithub-Open%20project-orange?style=for-the-badge)](https://omgithub.com/devproject92/devprojectmusic)
[![GitHub](https://img.shields.io/badge/GitHub-Source-181717?logo=github&style=for-the-badge)](https://github.com/devproject92/devprojectmusic)

- 🎮 [Open the project](https://omgithub.com/devproject92/devprojectmusic).
- ✨ [Remix this project](https://omgithub.com/?remix=devproject92%2Fdevprojectmusic).
- 💻 [Explore the source](https://github.com/devproject92/devprojectmusic).
- 🛠️ [Check build runs](https://github.com/devproject92/devprojectmusic/actions).
- 🐛 [Report an issue](https://github.com/devproject92/devprojectmusic/issues).
- 👤 [Explore the creator's projects](https://omgithub.com/devproject92).
- 🌍 [Create with OMGithub](https://omgithub.com).
- 🧬 [Explore the remix source](https://github.com/devproject92/devprojectmusic).
<!-- omgithub:readme:end -->

# Music

Aplikasi musik bergaya iOS dengan palet hitam, putih, dan abu-abu.
Desain mengikuti file asli `monokrom_music.zip`; yang berubah hanya nama
aplikasi menjadi **Music**.

Ada 4 layar: Beranda, Cari, Pustaka, dan Sedang Diputar.

## Cara menjalankan

Folder platform (`android/` dan `web/`) sudah ada di repo, jadi tidak perlu
`flutter create` lagi:

```bash
flutter pub get
flutter run              # Android / perangkat
flutter run -d chrome    # versi web
```

Pratinjau web memakai `./start.sh`: menjalankan `flutter build web --release`
(hanya bila perlu) lalu menyajikan `build/web` di `PORT` (default 3000).

## Struktur

- `lib/main.dart` : titik masuk, tab bar bawah, dan mini player
- `lib/player_state.dart` : status pemutar (lagu, putar/jeda, volume, progres)
- `lib/data.dart` : data contoh lagu
- `lib/theme.dart` : warna dan gaya teks
- `lib/screens/` : Beranda, Cari, Pustaka, Sedang Diputar
- `lib/widgets/` : sampul album (digambar dengan kode), mini player, pil volume
- `test/` : tes widget dan tes logika pemutar

## Catatan

- Belum ada audio sungguhan. Putar/jeda, progres, dan volume hanya simulasi
  tampilan.
- Sampul album digambar dengan `CustomPainter`, jadi tidak butuh file gambar.
- Pil volume di layar Sedang Diputar: ketuk untuk menaikkan 25%, atau geser ke
  atas/bawah.
- Layar Sedang Diputar bisa digulir, jadi tidak meluber di layar pendek
  (landscape HP atau jendela browser yang pendek).
- Masih tampilan saja: kolom pencarian belum memfilter lagu, kartu genre belum
  bisa ditekan, tombol `···`/lirik/perangkat/antrean belum ada aksinya, durasi
  semua lagu sama (3:32), dan status "suka" hilang saat ganti lagu.
- APK release masih ditandatangani debug key dan `applicationId` masih
  `com.contoh.music`, jadi belum siap dipublikasikan ke Play Store.

## Build APK via GitHub Actions

Workflow `.github/workflows/build-apk.yml` jalan otomatis pada push ke `main`,
setiap pull request, atau manual (Actions > Build APK > Run workflow).
`flutter analyze` dan `flutter test` harus lolos dulu sebelum APK dibangun.

Hasilnya ada di Artifacts:
- `music-debug-apk` (`app-debug.apk`)
- `music-release-apk` (`app-release.apk`, signed debug key)
