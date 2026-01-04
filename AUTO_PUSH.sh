#!/bin/bash

# MotionCore Otomatik GitHub Push Script
# GitHub'da repository oluşturduktan sonra bu scripti çalıştırın

echo "🚀 MotionCore GitHub'a push ediliyor..."
echo ""

# GitHub bilgileri
GITHUB_USER="huseyindemirok"
REPO_NAME="motioncore"
GITHUB_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

# Remote kontrolü ve ayarlama
if git remote get-url origin &>/dev/null; then
    echo "✅ Remote zaten var, güncelleniyor..."
    git remote set-url origin "${GITHUB_URL}"
else
    echo "➕ Remote ekleniyor..."
    git remote add origin "${GITHUB_URL}"
fi

# Branch kontrolü
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "🔄 Branch main olarak ayarlanıyor..."
    git branch -M main
fi

# Son commit kontrolü
echo "📋 Son commit'ler:"
git log --oneline -5

echo ""
echo "📤 GitHub'a push ediliyor..."
echo "⚠️  GitHub kullanıcı adı ve şifre/token istenebilir"
echo ""

# Push işlemi
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Başarılı! Repository hazır:"
    echo "🌐 ${GITHUB_URL}"
    echo ""
    echo "👥 Şimdi yuso1134'ü collaborator olarak ekleyin:"
    echo "   ${GITHUB_URL}/settings/access"
    echo ""
    echo "📝 Collaborator ekleme adımları:"
    echo "   1. Settings → Collaborators → Add people"
    echo "   2. 'yuso1134' yaz ve kullanıcıyı seç"
    echo "   3. İzin: Write (kod değiştirme)"
    echo "   4. Add yuso1134 to this repository"
else
    echo ""
    echo "❌ Push başarısız!"
    echo ""
    echo "🔧 Çözüm önerileri:"
    echo "   1. GitHub'da repository oluşturduğunuzdan emin olun"
    echo "   2. Personal Access Token kullanın:"
    echo "      https://github.com/settings/tokens"
    echo "   3. Token ile push yapın:"
    echo "      git push -u origin main"
    echo "      (Username: ${GITHUB_USER})"
    echo "      (Password: Token'ı yapıştırın)"
fi

