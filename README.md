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

Aplikasi musik bergaya iOS, hanya hitam, putih, dan abu-abu.
Desain disamakan persis dengan file asli `monokrom_music.zip` — tidak diubah,
hanya nama aplikasi diganti menjadi **Music**.

Ada 4 layar: Beranda, Cari, Pustaka, dan Sedang Diputar.

## Cara menjalankan

Folder platform dibuat oleh Flutter:

```bash
flutter create . --project-name music --org com.contoh
flutter pub get
flutter run
```

## Struktur

- `lib/main.dart` : titik masuk, tab bar bawah, dan mini player
- `lib/player_state.dart` : status pemutar (lagu, putar/jeda, volume, progres)
- `lib/data.dart` : data contoh lagu
- `lib/theme.dart` : warna dan gaya teks
- `lib/screens/` : Beranda, Cari, Pustaka, Sedang Diputar
- `lib/widgets/` : sampul album (digambar dengan kode), mini player, pil volume

## Catatan

- Belum ada audio sungguhan. Putar/jeda, progres, dan volume hanya simulasi tampilan.
- Sampul album digambar dengan `CustomPainter`, jadi tidak butuh file gambar.
- Pil volume di layar Sedang Diputar: ketuk untuk menaikkan 25%, atau geser ke atas/bawah.

## Build APK via GitHub Actions

Workflow `.github/workflows/build-apk.yml` otomatis jalan tiap push ke `main`,
pull request, atau manual (Actions > Build APK > Run workflow).

Hasilnya ada di Artifacts:
- `music-debug-apk` (`app-debug.apk`)
- `music-release-apk` (`app-release.apk`, signed debug key)

Build lokal juga sudah diverifikasi:
`flutter analyze` bersih, `flutter test` lolos, `flutter build apk --debug`
dan `--release` berhasil.
