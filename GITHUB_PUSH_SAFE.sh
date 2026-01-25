#!/bin/bash
# ============================================
# 📤 GitHub'ga Xavfsiz Push
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              GITHUB'GA PUSH QILISH                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Git remote qo'shish (agar yo'q bo'lsa)
if ! git remote | grep -q origin; then
    echo "⚠️  Git remote topilmadi!"
    echo ""
    echo "Quyidagi buyruqni bajarib remote qo'shing:"
    echo ""
    echo "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo ""
    echo "Yoki SSH orqali:"
    echo "  git remote add origin git@github.com:YOUR_USERNAME/YOUR_REPO.git"
    echo ""
    read -p "Remote qo'shildimi? (y/n): " answer
    if [ "$answer" != "y" ]; then
        echo "❌ Remote qo'shilmadi. Push qilish bekor qilindi."
        exit 1
    fi
fi

# Current branch
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="master"
    git checkout -b master
fi

echo "📋 Branch: $BRANCH"
echo ""

# Status
echo "📊 Git Status:"
git status --short
echo ""

# Commit (agar o'zgarishlar bo'lsa)
if [ -n "$(git status --porcelain)" ]; then
    echo "💾 O'zgarishlar bor. Commit qilinmoqda..."
    git add .
    git commit -m "feat: Enhanced features v2.0 - 11 new components, 7 backend models, bug fixes"
    echo "✅ Commit qilindi"
    echo ""
fi

# Push
echo "🚀 GitHub'ga push qilinmoqda..."
echo ""

if git push -u origin $BRANCH; then
    echo ""
    echo "✅ Muvaffaqiyatli push qilindi!"
    echo ""
    echo "🌐 Repository: $(git remote get-url origin)"
    echo "📦 Branch: $BRANCH"
else
    echo ""
    echo "❌ Push qilishda xatolik!"
    echo ""
    echo "Tekshirish:"
    echo "  1. GitHub repository mavjudligi"
    echo "  2. Authentication (token yoki SSH key)"
    echo "  3. Internet ulanishi"
    exit 1
fi

echo ""
echo "✅ Barcha o'zgarishlar GitHub'ga yuklandi!"
