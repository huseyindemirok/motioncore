import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/planet_state.dart';

class PlanetWidget extends StatelessWidget {
  final PlanetState planetState;

  const PlanetWidget({
    super.key,
    required this.planetState,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenWidth < 380;
    final planetSize = isSmall 
        ? screenWidth * 0.7 
        : (screenHeight < 700 ? screenWidth * 0.75 : screenWidth * 0.65);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gezegen Container
        SizedBox(
          width: planetSize + 40,
          height: planetSize + 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle outer glow - çok hafif
              Container(
                width: planetSize + 20,
                height: planetSize + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getSubtleGlowColor(),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Ana gezegen - Gerçekçi texture
              Container(
                width: planetSize,
                height: planetSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: _getRealisticGradient(),
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                  boxShadow: [
                    // Subtle shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: RealisticPlanetPainter(
                    planetState: planetState,
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(
                    duration: const Duration(seconds: 40),
                    curve: Curves.linear,
                  ),

              // Su katmanı - Daha gerçekçi
              if (planetState.hydrosphere > 0.2)
                Container(
                  width: planetSize * 0.98,
                  height: planetSize * 0.98,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.shade700.withOpacity(0.6 * planetState.hydrosphere),
                        Colors.blue.shade800.withOpacity(0.4 * planetState.hydrosphere),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.01, 1.01),
                      duration: const Duration(seconds: 4),
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.01, 1.01),
                      end: const Offset(1.0, 1.0),
                      duration: const Duration(seconds: 4),
                      curve: Curves.easeInOut,
                    ),

              // Bulutlar - Daha gerçekçi ve sade
              if (planetState.phase == PlanetPhase.blueHope && planetState.hydrosphere > 0.3)
                ..._buildRealisticClouds(planetSize),

              // Yaşam katmanı - Daha gerçekçi
              if (planetState.biosphere > 0.2)
                Container(
                  width: planetSize * 0.92,
                  height: planetSize * 0.92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.green.shade700.withOpacity(0.5 * planetState.biosphere),
                        Colors.green.shade800.withOpacity(0.3 * planetState.biosphere),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Faz bilgisi - Sade
        Text(
          _getPhaseName(),
          style: GoogleFonts.orbitron(
            fontSize: isSmall ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(planetState.totalProgress * 100).toInt()}% Terraformed',
          style: GoogleFonts.exo2(
            fontSize: isSmall ? 11 : 12,
            color: Colors.white60,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Color _getSubtleGlowColor() {
    switch (planetState.phase) {
      case PlanetPhase.deadRock:
        return Colors.grey.withOpacity(0.15);
      case PlanetPhase.blueHope:
        return Colors.blue.withOpacity(0.2);
      case PlanetPhase.greenEden:
        return Colors.green.withOpacity(0.2);
    }
  }

  List<Color> _getRealisticGradient() {
    switch (planetState.phase) {
      case PlanetPhase.deadRock:
        return [
          const Color(0xFF3A3A3A),
          const Color(0xFF2D2D2D),
          const Color(0xFF1F1F1F),
          const Color(0xFF2D2D2D),
        ];
      case PlanetPhase.blueHope:
        return [
          const Color(0xFF1E3A5F),
          const Color(0xFF0F4C75),
          const Color(0xFF0A2E4D),
          const Color(0xFF1E3A5F),
        ];
      case PlanetPhase.greenEden:
        return [
          const Color(0xFF2D5016),
          const Color(0xFF1F3A0F),
          const Color(0xFF152A08),
          const Color(0xFF2D5016),
        ];
    }
  }

  String _getPhaseName() {
    switch (planetState.phase) {
      case PlanetPhase.deadRock:
        return 'The Dead Rock';
      case PlanetPhase.blueHope:
        return 'Blue Hope';
      case PlanetPhase.greenEden:
        return 'Green Eden';
    }
  }

  List<Widget> _buildRealisticClouds(double planetSize) {
    final containerSize = planetSize + 40;
    final offset = (containerSize - planetSize) / 2;
    
    return [
      // Bulut 1 - Daha gerçekçi şekil
      Positioned(
        top: offset + planetSize * 0.2,
        left: offset + planetSize * 0.25,
        child: Container(
          width: planetSize * 0.28,
          height: planetSize * 0.16,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25 * planetState.hydrosphere),
            borderRadius: BorderRadius.circular(planetSize * 0.08),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.15 * planetState.hydrosphere),
                blurRadius: 8,
              ),
            ],
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .moveX(
              begin: 0,
              end: 8,
              duration: const Duration(seconds: 12),
              curve: Curves.easeInOut,
            )
            .then()
            .moveX(
              begin: 8,
              end: 0,
              duration: const Duration(seconds: 12),
              curve: Curves.easeInOut,
            ),
      ),
      // Bulut 2
      Positioned(
        top: offset + planetSize * 0.5,
        right: offset + planetSize * 0.25,
        child: Container(
          width: planetSize * 0.22,
          height: planetSize * 0.14,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2 * planetState.hydrosphere),
            borderRadius: BorderRadius.circular(planetSize * 0.07),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.12 * planetState.hydrosphere),
                blurRadius: 6,
              ),
            ],
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .moveX(
              begin: 0,
              end: -6,
              duration: const Duration(seconds: 15),
              curve: Curves.easeInOut,
            )
            .then()
            .moveX(
              begin: -6,
              end: 0,
              duration: const Duration(seconds: 15),
              curve: Curves.easeInOut,
            ),
      ),
    ];
  }
}

// Gerçekçi gezegen texture painter
class RealisticPlanetPainter extends CustomPainter {
  final PlanetState planetState;

  RealisticPlanetPainter({
    required this.planetState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Stage 1: Dead Rock - Gerçekçi kraterler ve yüzey detayları
    if (planetState.phase == PlanetPhase.deadRock) {
      // Büyük kraterler - derinlik efekti
      paint.color = const Color(0xFF1A1A1A);
      _drawCrater(canvas, center, radius * 0.3, radius * 0.12, paint);
      _drawCrater(canvas, center, radius * 0.4, radius * 0.1, paint);
      _drawCrater(canvas, center, radius * 0.25, radius * 0.08, paint);
      
      // Orta kraterler
      paint.color = const Color(0xFF252525);
      for (int i = 0; i < 6; i++) {
        final angle = (i / 6) * math.pi * 2;
        final dist = radius * (0.5 + (i % 2) * 0.15);
        _drawCrater(
          canvas,
          Offset(
            center.dx + math.cos(angle) * dist,
            center.dy + math.sin(angle) * dist,
          ),
          radius * 0.05,
          radius * 0.04,
          paint,
        );
      }
      
      // Küçük kraterler ve yüzey detayları
      paint.color = const Color(0xFF2A2A2A);
      for (int i = 0; i < 12; i++) {
        final angle = (i / 12) * math.pi * 2;
        final dist = radius * (0.3 + (i % 3) * 0.2);
        canvas.drawCircle(
          Offset(
            center.dx + math.cos(angle) * dist,
            center.dy + math.sin(angle) * dist,
          ),
          radius * 0.02,
          paint,
        );
      }
    }

    // Stage 2: Blue Hope - Gerçekçi okyanuslar ve kara parçaları
    if (planetState.phase == PlanetPhase.blueHope && planetState.hydrosphere > 0.2) {
      // Büyük okyanus alanı
      paint.color = Colors.blue.shade800.withOpacity(0.7 * planetState.hydrosphere);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + radius * 0.25),
          width: radius * 1.5,
          height: radius * 1.0,
        ),
        paint,
      );
      
      // Küçük su alanları
      paint.color = Colors.blue.shade700.withOpacity(0.6 * planetState.hydrosphere);
      _drawWaterArea(canvas, center, radius * 0.35, radius * 0.3, paint);
      _drawWaterArea(canvas, center, radius * 0.4, radius * 0.25, paint);
      
      // Kara parçaları (ada görünümü)
      paint.color = const Color(0xFF2A4A3A);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
          width: radius * 0.4,
          height: radius * 0.3,
        ),
        paint,
      );
    }

    // Stage 3: Green Eden - Gerçekçi bitki örtüsü ve ormanlar
    if (planetState.phase == PlanetPhase.greenEden && planetState.biosphere > 0.2) {
      // Büyük orman alanları
      paint.color = Colors.green.shade800.withOpacity(0.6 * planetState.biosphere);
      _drawVegetationArea(canvas, center, radius * 0.3, radius * 0.4, paint);
      _drawVegetationArea(canvas, center, radius * 0.35, radius * 0.35, paint);
      
      // Küçük bitki alanları
      paint.color = Colors.green.shade700.withOpacity(0.5 * planetState.biosphere);
      for (int i = 0; i < 8; i++) {
        final angle = (i / 8) * math.pi * 2;
        final dist = radius * 0.55;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              center.dx + math.cos(angle) * dist,
              center.dy + math.sin(angle) * dist,
            ),
            width: radius * 0.15,
            height: radius * 0.12,
          ),
          paint,
        );
      }
    }
  }

  void _drawCrater(Canvas canvas, Offset center, double radius, double depth, Paint paint) {
    final baseColor = paint.color;
    // Krater gölgesi (derinlik efekti)
    paint.color = baseColor.withOpacity(0.8);
    canvas.drawCircle(center, radius, paint);
    
    // Krater içi (daha koyu)
    paint.color = baseColor.withOpacity(0.6);
    canvas.drawCircle(center, radius * 0.7, paint);
    
    // Krater kenarı (hafif highlight)
    paint.color = baseColor.withOpacity(0.3);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.3), radius * 0.2, paint);
  }

  void _drawWaterArea(Canvas canvas, Offset center, double offsetX, double offsetY, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + offsetX, center.dy + offsetY),
        width: center.dx * 0.6,
        height: center.dy * 0.4,
      ),
      paint,
    );
  }

  void _drawVegetationArea(Canvas canvas, Offset center, double offsetX, double size, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + offsetX, center.dy - offsetX * 0.5),
        width: size,
        height: size * 0.7,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
