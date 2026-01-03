# 🚀 GitHub'a Yükleme Adımları

## Hızlı Başlangıç

### 1. GitHub'da Repository Oluştur
1. https://github.com adresine git
2. Sağ üstteki **+** → **New repository**
3. Repository adı: `motioncore` (veya istediğiniz isim)
4. **Public** veya **Private** seç
5. **Initialize this repository with a README** seçeneğini **işaretleme**
6. **Create repository** tıkla

### 2. Local Repository'yi GitHub'a Bağla

```bash
cd /Users/huseyin/Desktop/MotionCore

# GitHub'dan aldığınız URL'i kullanın (örnek):
git remote add origin https://github.com/KULLANICI_ADI/motioncore.git

# Branch'i main olarak ayarla
git branch -M main

# İlk push
git push -u origin main
```

### 3. Collaborator Ekleme

1. GitHub repository sayfasına git
2. **Settings** sekmesine tıkla
3. Sol menüden **Collaborators** seç
4. **Add people** butonuna tıkla
5. Kullanıcının GitHub kullanıcı adını veya email'ini gir
6. İzin seviyesi seç:
   - **Read**: Sadece görüntüleme
   - **Write**: Kod değiştirme ve push yapabilme (önerilen)
   - **Admin**: Tam yetki

### 4. Collaborator'ın Yapması Gerekenler

```bash
# Repository'yi clone et
git clone https://github.com/KULLANICI_ADI/motioncore.git
cd motioncore

# Dependencies'leri yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## Sonraki Adımlar

### Değişiklikleri Paylaşma
```bash
# Değişiklikleri commit et
git add .
git commit -m "feat: yeni özellik eklendi"

# GitHub'a push et
git push
```

### Güncel Değişiklikleri Çekme
```bash
# GitHub'dan güncel değişiklikleri çek
git pull origin main
```

## Alternatif: GitHub Desktop

Eğer komut satırı kullanmak istemiyorsanız:
1. https://desktop.github.com adresinden GitHub Desktop'ı indir
2. Repository'yi aç
3. Değişiklikleri commit et ve push yap

---

**Not:** İlk push'tan önce GitHub'da repository oluşturmanız gerekiyor!

