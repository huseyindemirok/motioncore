import 'package:flutter/material.dart';
import 'dart:math';

class StarryBackground extends StatelessWidget {
  final Widget child;

  const StarryBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Yıldızlı arka plan
        CustomPaint(
          painter: StarsPainter(),
          size: Size.infinite,
        ),
        // Circuit board çizgileri
        CustomPaint(
          painter: CircuitLinesPainter(),
          size: Size.infinite,
        ),
        // İçerik
        child,
      ],
    );
  }
}

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = Random(42); // Sabit seed ile aynı yıldızlar

    // Yıldızlar çiz
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 0.5;
      
      canvas.drawCircle(
        Offset(x, y),
        starSize,
        paint..color = Colors.white.withOpacity(random.nextDouble() * 0.8 + 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircuitLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Yatay çizgiler
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Dikey çizgiler
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

