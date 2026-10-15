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
}
