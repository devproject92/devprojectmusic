import 'package:flutter_test/flutter_test.dart';
import 'package:music/data.dart';
import 'package:music/player_state.dart';
import 'package:music/theme.dart';

void main() {
  late PlayerState player;

  setUp(() {
    // Mulai dalam keadaan jeda supaya tidak ada timer yang menggantung.
    player = PlayerState()..togglePlay();
    addTearDown(player.dispose);
  });

  test('select mengganti lagu, mereset posisi, dan mulai memutar', () {
    player.select(2);

    expect(player.index, 2);
    expect(player.elapsed, 0);
    expect(player.playing, isTrue);
  });

  test('next berputar kembali ke lagu pertama', () {
    player.select(tracks.length - 1);
    player.next();

    expect(player.index, 0);
    expect(player.elapsed, 0);
  });

  test('previous me-reset posisi bila lagu sudah lewat 3 detik', () {
    player.select(2);
    player.seek(30);
    player.previous();

    expect(player.index, 2);
    expect(player.elapsed, 0);
  });

  test('previous pindah ke lagu sebelumnya bila posisi masih di awal', () {
    player.select(0);
    player.seek(1);
    player.previous();

    expect(player.index, tracks.length - 1);
  });

  test('seek dan setVolume dibatasi pada rentang yang sah', () {
    player.seek(-5);
    expect(player.elapsed, 0);

    player.seek(PlayerState.duration + 100);
    expect(player.elapsed, PlayerState.duration);

    player.setVolume(-1);
    expect(player.volume, 0);

    player.setVolume(4);
    expect(player.volume, 1);
  });

  test('cycleVolume naik 25% tiap ketukan lalu kembali ke 0', () {
    player.setVolume(0);

    for (final expected in [0.25, 0.5, 0.75, 1.0, 0.0]) {
      player.cycleVolume();
      expect(player.volume, expected);
    }
  });

  test('toggleLike, toggleShuffle, dan toggleRepeat membalik status', () {
    expect(player.liked, isFalse);
    player.toggleLike();
    expect(player.liked, isTrue);

    expect(player.shuffle, isFalse);
    player.toggleShuffle();
    expect(player.shuffle, isTrue);

    expect(player.repeat, isFalse);
    player.toggleRepeat();
    expect(player.repeat, isTrue);
  });

  test('formatTime menampilkan menit:detik', () {
    expect(formatTime(0), '0:00');
    expect(formatTime(9), '0:09');
    expect(formatTime(84), '1:24');
    expect(formatTime(212), '3:32');
  });
}
