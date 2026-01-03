# 🤝 MotionCore - Collaboration Guide

## Başka Kullanıcıları Projeye Ekleme

### Yöntem 1: GitHub (Önerilen) ⭐

#### Adım 1: Git Repository Oluşturma
```bash
# Git repository'yi başlat
cd /Users/huseyin/Desktop/MotionCore
git init
git add .
git commit -m "Initial commit: MotionCore app"

# GitHub'da yeni repository oluştur (github.com)
# Sonra remote ekle:
git remote add origin https://github.com/KULLANICI_ADI/motioncore.git
git branch -M main
git push -u origin main
```

#### Adım 2: Collaborator Ekleme
1. GitHub repository sayfasına git
2. **Settings** → **Collaborators** → **Add people**
3. Kullanıcının GitHub kullanıcı adını veya email'ini gir
4. İzin seviyesi seç:
   - **Read**: Sadece görüntüleme
   - **Write**: Kod değiştirme ve push yapabilme
   - **Admin**: Tam yetki

#### Adım 3: Collaborator'ın Yapması Gerekenler
```bash
# Repository'yi clone et
git clone https://github.com/KULLANICI_ADI/motioncore.git
cd motioncore

# Dependencies'leri yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

### Yöntem 2: Cursor Spaces (Eğer Varsa)

1. Cursor'da **File** → **Share** veya **Collaborate**
2. Space oluştur veya mevcut space'e davet et
3. Davet linkini paylaş

### Yöntem 3: Proje Klasörünü Paylaşma

#### Yerel Ağ Üzerinden:
```bash
# Proje klasörünü paylaş
# macOS: System Preferences → Sharing → File Sharing
# Klasörü paylaşıma aç
```

#### Cloud Storage:
- Google Drive, Dropbox, OneDrive'a yükle
- Klasörü paylaş
- **Not:** `.git` klasörünü de paylaş (Git history için)

### Yöntem 4: GitLab / Bitbucket

GitHub'a benzer şekilde:
1. GitLab/Bitbucket'ta repository oluştur
2. Collaborator ekle
3. Push/Pull yap

## İşbirliği İçin Best Practices

### 1. Branch Stratejisi
```bash
# Feature branch oluştur
git checkout -b feature/yeni-ozellik

# Değişiklikleri commit et
git add .
git commit -m "feat: yeni özellik eklendi"

# Main branch'e merge et
git checkout main
git merge feature/yeni-ozellik
git push
```

### 2. Commit Mesajları
```
feat: yeni özellik eklendi
fix: bug düzeltildi
docs: dokümantasyon güncellendi
style: kod formatı düzenlendi
refactor: kod yeniden yapılandırıldı
test: test eklendi
```

### 3. Pull Request (PR) Kullanımı
1. Feature branch'te çalış
2. GitHub'da **Pull Request** oluştur
3. Code review yap
4. Merge et

### 4. Conflict Çözümü
```bash
# En güncel değişiklikleri al
git pull origin main

# Conflict varsa çöz
# Sonra commit et
git add .
git commit -m "fix: conflict çözüldü"
git push
```

## Gerekli Bilgiler

### Proje Gereksinimleri
- Flutter SDK (3.0.0+)
- Dart SDK
- Android Studio (Android için)
- Xcode (iOS için - macOS'ta)

### Kurulum Adımları
```bash
# 1. Repository'yi clone et
git clone [REPO_URL]
cd motioncore

# 2. Dependencies'leri yükle
flutter pub get

# 3. Emülatör başlat veya fiziksel cihaz bağla
flutter devices

# 4. Uygulamayı çalıştır
flutter run
```

### Önemli Dosyalar
- `pubspec.yaml` - Dependencies
- `lib/main.dart` - Uygulama giriş noktası
- `lib/providers/motion_core_provider.dart` - State management
- `lib/screens/` - Ekranlar
- `lib/widgets/` - Widget'lar

## İletişim

- **GitHub Issues**: Bug bildirimi ve feature request için
- **Pull Requests**: Kod değişiklikleri için
- **Discussions**: Genel tartışmalar için

## Güvenlik Notları

⚠️ **Önemli:**
- `.env` dosyalarını commit etme (sensitive data)
- API keys'leri public repository'de saklama
- `.gitignore` dosyasını kontrol et

## Yardım

Sorun yaşarsanız:
1. `flutter doctor` çalıştır
2. `flutter clean && flutter pub get` dene
3. GitHub Issues'da soru sor

---

**Son Güncelleme:** 2025-01-03

