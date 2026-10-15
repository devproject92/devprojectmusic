import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';

/// Sampul album hitam putih yang digambar dengan kode.
class AlbumArt extends StatelessWidget {
  const AlbumArt({
    super.key,
    required this.style,
    required this.size,
    this.radius = 12,
    this.borderColor = AppColors.line,
  });

  final ArtStyle style;
  final double size;
  final double radius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final inner = math.max(radius - 1, 0).toDouble();
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(inner),
          child: CustomPaint(
            painter: _ArtPainter(style),
            size: Size.square(size),
          ),
        ),
      ),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.style);

  final ArtStyle style;

  static final Paint _black = Paint()..color = Colors.black;
  static final Paint _white = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    switch (style) {
      case ArtStyle.rings:
        _rings(canvas, size, 8);
      case ArtStyle.ringsFine:
        _rings(canvas, size, 18);
      case ArtStyle.dots:
        _rings(canvas, size, 18,
            center: Offset(size.width * 0.2, size.height * 0.8));
      case ArtStyle.diagonal:
        canvas.drawRect(rect, _white);
        final path = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, _black);
      case ArtStyle.diagonalInv:
        canvas.drawRect(rect, _black);
        final path = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, _white);
      case ArtStyle.stripes:
        canvas.drawRect(rect, _white);
        const bands = 14;
        final w = size.width / bands;
        for (var i = 0; i < bands; i += 2) {
          canvas.drawRect(Rect.fromLTWH(i * w, 0, w, size.height), _black);
        }
      case ArtStyle.dot:
        canvas.drawRect(rect, _black);
        canvas.drawCircle(size.center(Offset.zero), size.width * 0.21, _white);
      case ArtStyle.grey:
        final paint = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8E8E93), Color(0xFF1C1C1E)],
          ).createShader(rect);
        canvas.drawRect(rect, paint);
    }
  }

  void _rings(Canvas canvas, Size size, int bands, {Offset? center}) {
    final c = center ?? size.center(Offset.zero);
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    final maxR = corners.map((o) => (o - c).distance).reduce(math.max);
    for (var k = bands; k >= 1; k--) {
      canvas.drawCircle(c, maxR * k / bands, k.isOdd ? _black : _white);
    }
  }

  @override
  bool shouldRepaint(covariant _ArtPainter oldDelegate) =>
      oldDelegate.style != style;
}
