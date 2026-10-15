import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grayText = Color(0xFF6C6C70);
  static const grayLight = Color(0xFFF2F2F7);
  static const line = Color(0xFFD1D1D6);
  static const chevron = Color(0xFF8E8E93);
  static const darkCard = Color(0xFF1C1C1E);
  static const darkTrack = Color(0xFF3A3A3C);
  static const lightText = Color(0xFFA1A1A6);
}

/// Nama keluarga huruf dari `pubspec.yaml` (assets/fonts).
const String appFontFamily = 'Inter';

class AppText {
  static const largeTitle = TextStyle(
    fontSize: 34,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.ink,
  );
  static const section = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const rowTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
  static const rowSub = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );
  static const label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
}

String formatTime(int seconds) {
  final m = seconds ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
