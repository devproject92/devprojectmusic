import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'data.dart';

/// Status pemutar sederhana (simulasi, belum memutar audio sungguhan).
class PlayerState extends ChangeNotifier {
  PlayerState() {
    _syncTimer();
  }

  static const int duration = 212;

  int index = 0;
  bool playing = true;
  bool liked = false;
  bool shuffle = false;
  bool repeat = false;
  double volume = 0.5;
  int elapsed = 84;

  Timer? _timer;
  final math.Random _random = math.Random();

  Track get track => tracks[index];

  void _syncTimer() {
    _timer?.cancel();
    if (playing) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    if (elapsed + 1 >= duration) {
      if (repeat) {
        elapsed = 0;
      } else {
        next();
        return;
      }
    } else {
      elapsed++;
    }
    notifyListeners();
  }

  void _go(int i) {
    index = i;
    elapsed = 0;
    liked = false;
    notifyListeners();
  }

  void select(int i) {
    index = i;
    elapsed = 0;
    liked = false;
    playing = true;
    _syncTimer();
    notifyListeners();
  }

  void togglePlay() {
    playing = !playing;
    _syncTimer();
    notifyListeners();
  }

  void next() {
    if (shuffle && tracks.length > 1) {
      var i = index;
      while (i == index) {
        i = _random.nextInt(tracks.length);
      }
      _go(i);
    } else {
      _go((index + 1) % tracks.length);
    }
  }

  void previous() {
    if (elapsed > 3) {
      elapsed = 0;
      notifyListeners();
    } else {
      _go((index - 1 + tracks.length) % tracks.length);
    }
  }

  void seek(double value) {
    elapsed = value.round().clamp(0, duration).toInt();
    notifyListeners();
  }

  void toggleLike() {
    liked = !liked;
    notifyListeners();
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    repeat = !repeat;
    notifyListeners();
  }

  void setVolume(double value) {
    volume = value.clamp(0.0, 1.0).toDouble();
    notifyListeners();
  }

  /// Ketuk pil volume: naik 25%, kembali ke 0 setelah 100%.
  void cycleVolume() {
    if (volume >= 1) {
      volume = 0;
    } else {
      volume = ((volume * 4).floor() + 1) / 4;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final PlayerState player = PlayerState();
