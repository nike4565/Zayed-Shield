#!/bin/bash

echo "Starting repository sync..."

# التأكد أننا داخل مستودع Git
if [ ! -d ".git" ]; then
    echo "Error: This is not a Git repository."
    exit 1
fi

# سحب التحديثات من GitHub
echo "Pulling latest changes..."
git pull --rebase origin main

# إضافة أي ملفات جديدة
echo "Adding new changes..."
git add .

# عمل commit تلقائي
commit_msg="Auto update $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_msg" 2>/dev/null

# رفع التحديثات
echo "Pushing changes..."
git push origin main

echo "Sync completed successfully."
