# 👥 Collaborator Ekleme Rehberi

## yuso1134 Kullanıcısını Ekleme

### Adım 1: GitHub'da Repository Oluştur (Eğer yoksa)

1. https://github.com/new adresine git
2. Repository adı: `motioncore`
3. **Public** veya **Private** seç
4. **Create repository** tıkla

### Adım 2: Kodları GitHub'a Push Et

#### Yöntem 1: GitHub Desktop (Kolay)
1. https://desktop.github.com adresinden GitHub Desktop'ı indir
2. Repository'yi aç
3. "Publish repository" butonuna tıkla

#### Yöntem 2: Terminal (Komut satırı)
```bash
cd /Users/huseyin/Desktop/MotionCore

# GitHub authentication için (ilk kez)
# Personal Access Token oluştur: https://github.com/settings/tokens
# Token'ı kullanarak push yap:

git remote add origin https://github.com/huseyindemirok/motioncore.git
git branch -M main
git push -u origin main
```

**Personal Access Token Oluşturma:**
1. https://github.com/settings/tokens adresine git
2. **Generate new token (classic)** tıkla
3. **repo** yetkisini seç
4. Token'ı kopyala
5. Push yaparken şifre yerine token'ı kullan

### Adım 3: yuso1134'ü Collaborator Olarak Ekle

1. https://github.com/huseyindemirok/motioncore adresine git
2. **Settings** sekmesine tıkla
3. Sol menüden **Collaborators** seç
4. **Add people** butonuna tıkla
5. **yuso1134** yaz ve kullanıcıyı seç
6. İzin seviyesi seç:
   - **Write**: Kod değiştirme ve push yapabilme ✅ (Önerilen)
   - **Read**: Sadece görüntüleme
   - **Admin**: Tam yetki
7. **Add yuso1134 to this repository** tıkla

### Adım 4: yuso1134'ün Yapması Gerekenler

yuso1134 kullanıcısı şu adımları takip etmeli:

```bash
# Repository'yi clone et
git clone https://github.com/huseyindemirok/motioncore.git
cd motioncore

# Dependencies'leri yükle
flutter pub get

# Uygulamayı çalıştır
flutter run

# Değişiklik yap ve push et
git add .
git commit -m "feat: yeni özellik"
git push origin main
```

## 🔐 Güvenlik Notları

- **Write** yetkisi: Kod değiştirme ve push yapabilir
- **Read** yetkisi: Sadece görüntüleme
- **Admin** yetkisi: Collaborator ekleme/çıkarma dahil tam yetki

## 📝 Alternatif: Fork & Pull Request

Eğer direkt collaborator eklemek istemiyorsanız:

1. yuso1134 repository'yi fork eder
2. Değişikliklerini yapar
3. Pull Request açar
4. Siz review edip merge edersiniz

Bu yöntem daha güvenlidir ve code review yapmanıza olanak tanır.

---

**Hızlı Linkler:**
- Repository: https://github.com/huseyindemirok/motioncore
- Collaborator Ekleme: https://github.com/huseyindemirok/motioncore/settings/access
- Personal Access Token: https://github.com/settings/tokens

