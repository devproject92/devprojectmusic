import 'package:flutter_test/flutter_test.dart';
import 'package:music/main.dart';
import 'package:music/player_state.dart';

void main() {
  testWidgets('Music app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonokromApp());
    await tester.pump();

    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Putar Ulang'), findsOneWidget);
    expect(find.text('Untuk Kamu'), findsOneWidget);

    // Hentikan timer simulasi pemutar agar tidak dianggap pending.
    player.dispose();
  });
}
