# 🤖 Otomatik Push Denemesi

Terminal'den push yapmaya çalıştım. Eğer authentication hatası aldıysanız:

## ✅ Çözüm: GitHub Desktop Kullanın

GitHub Desktop açıldı. Şimdi:

1. **GitHub Desktop'ta:**
   - File → Add Local Repository
   - `/Users/huseyin/Desktop/MotionCore` seçin
   - Add Repository tıklayın

2. **Push yapın:**
   - "Publish repository" butonuna tıklayın
   - Repository name: `motioncore`
   - Publish repository tıklayın

## 🔑 Alternatif: Token ile Terminal Push

Eğer terminal kullanmak isterseniz:

1. **Token oluşturun:**
   - https://github.com/settings/tokens
   - "Generate new token (classic)"
   - "repo" yetkisi seç
   - Token'ı kopyala

2. **Push yapın:**
```bash
cd /Users/huseyin/Desktop/MotionCore
git push -u origin main
# Username: huseyindemirok
# Password: (Token'ı yapıştır)
```

---

**GitHub Desktop en kolay yöntem! 🚀**

