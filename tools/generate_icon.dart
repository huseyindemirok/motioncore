import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  print('🚀 MotionCore Icon Generator');
  print('Creating space-themed app icon...');
  
  // 512x512 canvas oluştur
  final image = img.Image(width: 512, height: 512);
  
  // Arka plan - uzay gradient
  for (int y = 0; y < 512; y++) {
    for (int x = 0; x < 512; x++) {
      final distance = ((x - 256) * (x - 256) + (y - 256) * (y - 256)) / (256 * 256);
      final r = (0x1a * (1 - distance) + 0x0a * distance).toInt().clamp(0, 255);
      final g = (0x1a * (1 - distance) + 0x0a * distance).toInt().clamp(0, 255);
      final b = (0x3e * (1 - distance) + 0x2e * distance).toInt().clamp(0, 255);
      image.setPixel(x, y, img.ColorRgb8(r, g, b));
    }
  }
  
  // Yıldızlar
  final random = DateTime.now().millisecondsSinceEpoch;
  for (int i = 0; i < 50; i++) {
    final x = (i * 37 + random) % 512;
    final y = (i * 73 + random) % 512;
    final size = (i % 3) + 1;
    _drawCircle(image, x, y, size, img.ColorRgb8(255, 255, 255), filled: true);
  }
  
  // Ana gezegen/core - dış halka (cyan glow)
  for (int i = 0; i < 20; i++) {
    final radius = 200 + i;
    final opacity = (20 - i) / 20.0;
    _drawCircle(image, 256, 256, radius, 
        img.ColorRgb8(0, (255 * opacity).toInt(), (255 * opacity).toInt()), filled: false);
  }
  
  // Ana gezegen - gradient sphere
  for (int y = 0; y < 512; y++) {
    for (int x = 0; x < 512; x++) {
      final dx = x - 256;
      final dy = y - 256;
      final distance = (dx * dx + dy * dy) / (200 * 200);
      
      if (distance <= 1.0) {
        // 3D sphere efekti
        final nx = dx / 200.0;
        final ny = dy / 200.0;
        final nz = (1.0 - (nx * nx + ny * ny)).clamp(0.0, 1.0);
        final light = (nx * -0.3 + ny * -0.3 + nz * 0.9).clamp(0.0, 1.0);
        
        int r, g, b;
        if (distance < 0.4) {
          // Core (beyaz/cyan)
          r = (255 * light).toInt();
          g = (255 * light).toInt();
          b = (255 * light).toInt();
        } else if (distance < 0.6) {
          // Orta (cyan)
          r = (0 * light).toInt();
          g = ((128 + 127 * light) * light).toInt();
          b = ((255 * light)).toInt();
        } else {
          // Dış (mavi)
          r = (0 * light).toInt();
          g = ((64 + 64 * light) * light).toInt();
          b = ((170 + 85 * light) * light).toInt();
        }
        
        image.setPixel(x, y, img.ColorRgb8(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255)));
      }
    }
  }
  
  // Enerji halkaları
  for (int ring = 0; ring < 3; ring++) {
    final radius = (120 + ring * 30).toInt();
    final opacity = (0.6 - ring * 0.2).clamp(0.0, 1.0);
    _drawCircle(image, 256, 256, radius, 
        img.ColorRgb8(0, (255 * opacity).toInt(), (255 * opacity).toInt()), filled: false, thickness: 3);
  }
  
  // "MC" yazısı (basit pixel art)
  // M harfi
  _drawLetterM(image, 200, 240);
  // C harfi
  _drawLetterC(image, 280, 240);
  
  // Dosyayı kaydet
  final directory = Directory('assets/icon');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  
  final file = File('assets/icon/app_icon.png');
  file.writeAsBytesSync(img.encodePng(image));
  
  print('✅ Icon created successfully: ${file.path}');
  print('📦 Size: 512x512 pixels');
}

void _drawLetterM(img.Image image, int startX, int startY) {
  // M harfi için basit pixel art
  final color = img.ColorRgb8(255, 255, 255);
  // Sol dikey çizgi
  for (int y = 0; y < 60; y++) {
    image.setPixel(startX, startY + y, color);
    image.setPixel(startX + 1, startY + y, color);
  }
  // Sağ dikey çizgi
  for (int y = 0; y < 60; y++) {
    image.setPixel(startX + 40, startY + y, color);
    image.setPixel(startX + 41, startY + y, color);
  }
  // Sol eğik çizgi
  for (int i = 0; i < 20; i++) {
    image.setPixel(startX + i, startY + i, color);
    image.setPixel(startX + i + 1, startY + i, color);
  }
  // Sağ eğik çizgi
  for (int i = 0; i < 20; i++) {
    image.setPixel(startX + 40 - i, startY + i, color);
    image.setPixel(startX + 40 - i + 1, startY + i, color);
  }
}

void _drawLetterC(img.Image image, int startX, int startY) {
  // C harfi için basit pixel art
  final color = img.ColorRgb8(255, 255, 255);
  // Sol dikey çizgi
  for (int y = 10; y < 50; y++) {
    image.setPixel(startX, startY + y, color);
    image.setPixel(startX + 1, startY + y, color);
  }
  // Üst yatay çizgi
  for (int x = 0; x < 35; x++) {
    image.setPixel(startX + x, startY + 10, color);
    image.setPixel(startX + x, startY + 11, color);
  }
  // Alt yatay çizgi
  for (int x = 0; x < 35; x++) {
    image.setPixel(startX + x, startY + 50, color);
    image.setPixel(startX + x, startY + 51, color);
  }
}

void _drawCircle(img.Image image, int centerX, int centerY, int radius, img.ColorRgb8 color, {bool filled = false, int thickness = 1}) {
  if (filled) {
    // Dolu çember
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      for (int x = centerX - radius; x <= centerX + radius; x++) {
        if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
          final dx = x - centerX;
          final dy = y - centerY;
          final distance = (dx * dx + dy * dy);
          if (distance <= radius * radius) {
            image.setPixel(x, y, color);
          }
        }
      }
    }
  } else {
    // Çember çizgisi
    for (int angle = 0; angle < 360; angle++) {
      final rad = angle * math.pi / 180.0;
      for (int t = 0; t < thickness; t++) {
        final r = radius - thickness ~/ 2 + t;
        final x = (centerX + (r * math.cos(rad))).round();
        final y = (centerY + (r * math.sin(rad))).round();
        if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
          image.setPixel(x, y, color);
        }
      }
    }
  }
}

