import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music/main.dart';
import 'package:music/player_state.dart';
import 'package:music/widgets/mini_player.dart';

/// Mematikan timer simulasi pemutar tanpa membuang singleton `player`,
/// supaya tes lain di berkas ini masih bisa memakainya.
void pausePlayer() {
  if (player.playing) {
    player.togglePlay();
  }
}

/// Membuka aplikasi, lalu pindah ke tab Cari.
Future<void> openSearchTab(WidgetTester tester) async {
  await tester.pumpWidget(const MonokromApp());
  await tester.pump();
  await tester.tap(find.byIcon(Icons.search_rounded));
  await tester.pumpAndSettle();
}

void main() {
  setUp(pausePlayer);

  testWidgets('Music app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonokromApp());
    await tester.pump();

    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Putar Ulang'), findsOneWidget);
    expect(find.text('Untuk Kamu'), findsOneWidget);

    // Timer simulasi pemutar harus berhenti sebelum tes selesai.
    pausePlayer();
  });

  testWidgets('Layar Sedang Diputar tidak meluber di layar pendek',
      (WidgetTester tester) async {
    // 720x360 = HP landscape atau jendela browser yang pendek.
    tester.view.physicalSize = const Size(720, 360);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MonokromApp());
    await tester.pump();

    await tester.tap(find.byType(MiniPlayer));
    await tester.pumpAndSettle();

    expect(find.text('SEDANG DIPUTAR'), findsOneWidget);

    // Overflow RenderFlex akan menggagalkan tes ini lewat FlutterError.
    pausePlayer();
  });

  testWidgets('Isi layar pendek bisa digulir hingga kontrol terbawah',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 320);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MonokromApp());
    await tester.pump();
    await tester.tap(find.byType(MiniPlayer));
    await tester.pumpAndSettle();

    final queueIcon = find.byIcon(Icons.queue_music_rounded);
    expect(queueIcon, findsOneWidget);
    expect(tester.getRect(queueIcon).top, greaterThan(320),
        reason: 'ikon Antrean harus berada di bawah area pandang');

    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -260));
    await tester.pumpAndSettle();

    expect(tester.getRect(queueIcon).top, lessThan(320),
        reason: 'setelah digulir, kontrol terbawah harus terlihat');

    pausePlayer();
  });

  testWidgets('Pencarian menyaring lagu dan menampilkan keadaan kosong',
      (WidgetTester tester) async {
    await openSearchTab(tester);

    // Sebelum mencari: kartu genre tampil.
    expect(find.text('Jelajahi Semua'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), 'hujan');
    await tester.pump();

    expect(find.text('Hasil'), findsOneWidget);
    expect(find.text('Jelajahi Semua'), findsNothing);
    expect(find.text('Hujan di Seberang'), findsWidgets);

    // Kata kunci tanpa hasil menampilkan keadaan kosong.
    await tester.enterText(find.byType(TextField), 'zzz tidak ada');
    await tester.pump();
    expect(find.textContaining('Tidak ada hasil'), findsOneWidget);

    // Tombol bersihkan mengembalikan kartu genre.
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.text('Jelajahi Semua'), findsOneWidget);
    expect(find.text('Hasil'), findsNothing);

    pausePlayer();
  });

  testWidgets('Hasil pencarian bisa diputar dan membuka layar pemutar',
      (WidgetTester tester) async {
    await openSearchTab(tester);

    await tester.enterText(find.byType(TextField), 'jalan pulang');
    await tester.pump();

    await tester.tap(find.text('Lagu · Band Contoh').first);
    await tester.pumpAndSettle();

    expect(find.text('SEDANG DIPUTAR'), findsOneWidget);
    expect(player.track.title, 'Jalan Pulang');

    pausePlayer();
  });
}
