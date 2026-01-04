#!/bin/bash

# MotionCore GitHub Push Script
# Repository oluşturduktan sonra bu scripti çalıştırın

GITHUB_USER="huseyindemirok"
REPO_NAME="motioncore"
GITHUB_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "🚀 MotionCore GitHub'a push ediliyor..."
echo "📍 Repository: ${GITHUB_URL}"
echo ""

# Remote kontrolü
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

# Push
echo "📤 Push ediliyor..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Başarılı! Repository hazır:"
    echo "🌐 ${GITHUB_URL}"
    echo ""
    echo "📝 Collaborator eklemek için:"
    echo "   1. ${GITHUB_URL} adresine git"
    echo "   2. Settings → Collaborators → Add people"
else
    echo ""
    echo "❌ Hata! Repository'yi oluşturduğunuzdan emin olun:"
    echo "   https://github.com/new"
    echo "   Repository adı: ${REPO_NAME}"
fi

