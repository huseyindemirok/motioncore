# 🚀 Push İçin 2 Yol

## Yöntem 1: GitHub Desktop (En Kolay) ⭐

1. **GitHub Desktop'ı indir ve kur:**
   - https://desktop.github.com
   - Kurulum tamamlandıktan sonra GitHub hesabınla giriş yap

2. **Repository'yi ekle:**
   - File → Add Local Repository
   - `/Users/huseyin/Desktop/MotionCore` klasörünü seç
   - "Publish repository" butonuna tıkla
   - Repository adı: `motioncore` (zaten oluşturulmuş)
   - "Publish repository" tıkla

**✅ Bu kadar! Kodlar GitHub'a yüklenecek.**

---

## Yöntem 2: Terminal (Token ile)

### 1. Token Oluştur:
1. https://github.com/settings/tokens adresine git
2. "Generate new token (classic)" tıkla
3. Token adı: "MotionCore Push"
4. Expiration: 90 days
5. **Scopes:** "repo" seçeneğini işaretle
6. "Generate token" tıkla
7. **Token'ı kopyala** (bir daha gösterilmeyecek!)

### 2. Push Yap:
```bash
cd /Users/huseyin/Desktop/MotionCore
git push -u origin main
```

**İstendiğinde:**
- Username: `huseyindemirok`
- Password: (Token'ı yapıştır - şifre değil!)

---

## ✅ Push Tamamlandıktan Sonra

### yuso1134'ü Collaborator Olarak Ekle:

1. https://github.com/huseyindemirok/motioncore/settings/access
2. "Add people" butonuna tıkla
3. `yuso1134` yaz ve kullanıcıyı seç
4. İzin seviyesi: **Write** (kod değiştirme)
5. "Add yuso1134 to this repository" tıkla

**✅ yuso1134 artık kodları görebilir ve değiştirebilir!**

---

**Öneri:** GitHub Desktop kullan, daha kolay! 🚀

