import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../player_state.dart';

/// Indikator volume modern berbentuk pil kaca.
/// Ketuk untuk menaikkan 25%, atau geser ke atas/bawah untuk mengubah level.
class VolumePill extends StatelessWidget {
  const VolumePill({super.key});

  static const double _width = 44;
  static const double _height = 156;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        final v = player.volume;
        final IconData icon = v == 0
            ? Icons.volume_off_rounded
            : v < 0.5
                ? Icons.volume_down_rounded
                : Icons.volume_up_rounded;

        return Semantics(
          label: 'Volume ${(v * 100).round()} persen',
          button: true,
          child: GestureDetector(
            onTap: player.cycleVolume,
            onVerticalDragUpdate: (d) => player.setVolume(v - d.delta.dy / _height),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: const Color(0x8C3C3C43),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x47FFFFFF)),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        width: _width,
                        height: _height * v,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Icon(
                          icon,
                          size: 22,
                          color: v >= 0.1 ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
