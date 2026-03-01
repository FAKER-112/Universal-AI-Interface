import 'package:flutter/material.dart';

class ConcentricCirclesLogo extends StatelessWidget {
  const ConcentricCirclesLogo({super.key, this.size = 24.0, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ConcentricCirclesPainter(
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _ConcentricCirclesPainter extends CustomPainter {
  _ConcentricCirclesPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final numCircles = 6;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (int i = 1; i <= numCircles; i++) {
      final radius = (maxRadius * 0.85 / numCircles) * i;
      double thickness = maxRadius * 0.15 * (numCircles - i + 1.5) / numCircles;
      if (thickness < 1.0) thickness = 1.0;
      paint.strokeWidth = thickness;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricCirclesPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
