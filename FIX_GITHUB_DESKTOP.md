# 🔧 GitHub Desktop Güvenlik Hatası Çözümü

## Sorun
macOS, GitHub Desktop'ı "geliştirici doğrulanamadığı için" açmayı engelliyor.

## ✅ Çözüm 1: Güvenlik Ayarlarından İzin Ver (Önerilen)

1. **System Preferences** (Sistem Tercihleri) açın
2. **Security & Privacy** (Güvenlik ve Gizlilik) seçin
3. **General** (Genel) sekmesine gidin
4. GitHub Desktop için bir uyarı göreceksiniz:
   - **"GitHub Desktop" was blocked because it is from an unidentified developer**
5. **"Open Anyway"** (Yine de Aç) butonuna tıklayın
6. GitHub Desktop açılacak

## ✅ Çözüm 2: Terminal ile Quarantine Kaldır

Terminal'de şu komutu çalıştırın:

```bash
# GitHub Desktop'ı bulun (genellikle Downloads veya Applications'da)
# Önce .dmg dosyasını mount edin, sonra:

xattr -d com.apple.quarantine "/Applications/GitHub Desktop.app"
```

Veya eğer Downloads'da ise:

```bash
# .dmg dosyasını mount edin (çift tıklayın)
# Sonra Applications klasörüne sürükleyin
# Terminal'de:

xattr -d com.apple.quarantine "/Applications/GitHub Desktop.app"
```

## ✅ Çözüm 3: Sağ Tık ile Aç

1. **Finder**'da GitHub Desktop.app dosyasını bulun
2. **Sağ tıklayın** (veya Control + tıklayın)
3. **"Open"** (Aç) seçeneğini tıklayın
4. Uyarı penceresinde **"Open"** butonuna tıklayın

## ✅ Çözüm 4: Alternatif - Terminal ile Push

GitHub Desktop yerine terminal kullanabilirsiniz:

### 1. Token Oluştur:
- https://github.com/settings/tokens
- "Generate new token (classic)"
- "repo" yetkisi seç
- Token'ı kopyala

### 2. Push Yap:
```bash
cd /Users/huseyin/Desktop/MotionCore
git push -u origin main
# Username: huseyindemirok
# Password: (Token'ı yapıştır)
```

---

## 🎯 Hızlı Çözüm

**En kolay yol:** System Preferences → Security & Privacy → "Open Anyway"

Veya terminal'de:
```bash
sudo spctl --master-disable
# (Güvenliği geçici olarak kapatır, sonra tekrar açın)
```

**Öneri:** Çözüm 1'i kullanın, en güvenli yöntem!

