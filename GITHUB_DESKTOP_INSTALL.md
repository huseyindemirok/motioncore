# 📦 GitHub Desktop Kurulum ve Güvenlik Çözümü

## 🔧 Adım Adım Çözüm

### 1. Zip Dosyasını Aç
- Downloads klasöründe `GitHubDesktop-x64.zip` dosyasını bulun
- **Çift tıklayın** veya **sağ tıklayıp "Open"** seçin
- macOS uyarı verirse: **"Open"** butonuna tıklayın

### 2. GitHub Desktop.app'i Applications'a Taşı
- Açılan pencerede **GitHub Desktop.app** dosyasını görün
- **Applications** klasörüne sürükleyin
- (Veya sağ tıklayıp "Copy" → Applications'a "Paste")

### 3. Güvenlik Uyarısını Çöz
GitHub Desktop'ı açmaya çalıştığınızda macOS uyarı verecek:

**Çözüm:**
1. **System Preferences** (Sistem Tercihleri) açın
   - (Açıldı - Security & Privacy sayfası)
2. **Security & Privacy** (Güvenlik ve Gizlilik) seçin
3. **General** (Genel) sekmesine gidin
4. Şu mesajı göreceksiniz:
   - *"GitHub Desktop" was blocked because it is from an unidentified developer*
5. **"Open Anyway"** (Yine de Aç) butonuna tıklayın
6. GitHub Desktop açılacak

### 4. Alternatif: Sağ Tık ile Aç
1. **Applications** klasöründe **GitHub Desktop.app** bulun
2. **Sağ tıklayın** (veya Control + tıklayın)
3. **"Open"** seçeneğini tıklayın
4. Uyarı penceresinde **"Open"** butonuna tıklayın

---

## 🚀 GitHub Desktop Kurulduktan Sonra

1. **GitHub Desktop'ı açın**
2. **GitHub hesabınızla giriş yapın**
3. **File** → **Add Local Repository**
4. `/Users/huseyin/Desktop/MotionCore` klasörünü seçin
5. **"Publish repository"** butonuna tıklayın

---

## ⚡ Hızlı Terminal Çözümü (Alternatif)

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

**Öneri:** System Preferences'dan "Open Anyway" ile çözün, en kolay yöntem! 🎯

