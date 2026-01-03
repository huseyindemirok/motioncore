# 🚀 MotionCore App Icon Kurulumu

## Adımlar:

1. **Icon Generator'ı Aç:**
   - `create_space_icon.html` dosyasını tarayıcıda açın
   - Icon otomatik olarak oluşturulacak

2. **Icon'u İndir:**
   - "Download Icon (512x512)" butonuna tıklayın
   - İndirilen dosyayı `app_icon.png` olarak kaydedin

3. **Icon'u Yerleştir:**
   - Dosyayı `assets/icon/app_icon.png` konumuna kopyalayın
   - Eğer klasör yoksa oluşturun

4. **Icon'u Uygula:**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Native Splash Screen'i Uygula:**
   ```bash
   flutter pub run flutter_native_splash:create
   ```

6. **Uygulamayı Yeniden Başlat:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Icon Özellikleri:
- ✅ Uzay temalı (siyah arka plan, yıldızlar)
- ✅ Cyan neon renkler
- ✅ "MC" harfleri (MotionCore)
- ✅ Pulsing/core animasyon efekti
- ✅ 512x512 piksel (yüksek kalite)

## Not:
Icon generator'da "Generate Icon" butonuna tıklayarak farklı varyasyonlar oluşturabilirsiniz.

