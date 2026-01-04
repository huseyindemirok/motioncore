#!/bin/bash

# GitHub Repository URL'ini buraya yapıştırın
# Örnek: https://github.com/KULLANICI_ADI/motioncore.git
GITHUB_URL=""

if [ -z "$GITHUB_URL" ]; then
    echo "❌ Hata: GitHub URL'ini girin!"
    echo "📝 Dosyayı düzenleyip GITHUB_URL değişkenine URL'inizi yazın"
    exit 1
fi

echo "🚀 GitHub'a push ediliyor..."
echo "📍 Repository: $GITHUB_URL"

# Remote ekle
git remote add origin "$GITHUB_URL" 2>/dev/null || git remote set-url origin "$GITHUB_URL"

# Branch'i main olarak ayarla
git branch -M main

# Push yap
git push -u origin main

echo "✅ Tamamlandı!"
echo "🌐 Repository: $GITHUB_URL"

