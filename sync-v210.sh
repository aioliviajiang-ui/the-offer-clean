#!/bin/bash
set -e

# 配置路径
SRC="/Users/ollie/Desktop/ oli‘s first game/grok/要约_v210.html"
DEST_DIR="/Users/ollie/Desktop/the-offer-clean"
DEST_HTML="$DEST_DIR/index.html"

echo "==> 1. 复制 v210 HTML..."
cp "$SRC" "$DEST_HTML"

echo "==> 2. 修正路径 ../final/ → final/..."
sed -i '' 's|\.\./final/|final/|g' "$DEST_HTML"

echo "==> 3. 检查引用的本地素材是否都存在..."
cd "$DEST_DIR"
python3 - <<'PY'
import re, os, sys

html = open('index.html', 'r', encoding='utf-8', errors='ignore').read()

# 收集 HTML 中引用的本地文件
refs = set()
refs.update(re.findall(r'url\(["\']?([^"\')]+)["\']?\)', html))
refs.update(re.findall(r'src=["\']([^"\']+)["\']', html))
refs.update(re.findall(r'href=["\']([^"\']+)["\']', html))

# 只检查真实媒体文件路径，过滤 JS 代码片段
MEDIA_EXTS = ('.png', '.jpg', '.jpeg', '.webp', '.gif', '.svg',
              '.mp4', '.webm', '.mov', '.mp3', '.wav', '.ogg', '.m4a')

def is_real_path(r):
    r = r.strip()
    if not r:
        return False
    # 跳过网络、data URI、锚点、blob
    if any(r.startswith(p) for p in ('data:', 'http://', 'https://', '#', 'blob:')):
        return False
    # 跳过明显是 JS 表达式的片段
    if any(c in r for c in '()+{}$`=?;,"\'<>|&*'):
        return False
    # 只检查媒体文件
    if not r.lower().endswith(MEDIA_EXTS):
        return False
    return True

missing = []
for r in refs:
    if not is_real_path(r):
        continue
    # 去掉可能的 URL hash/query
    r = r.split('?')[0].split('#')[0]
    if not os.path.exists(r):
        missing.append(r)

if missing:
    print("❌ 以下素材缺失，请补齐后再部署：")
    for m in missing:
        print(f"   - {m}")
    sys.exit(1)
else:
    print("✅ 所有引用的本地素材都已存在")
PY

echo "==> 4. GitHub + Cloudflare 一键发布"
read -p "是否立即 commit、push 并部署到 Cloudflare？ (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add -A
    if git diff --cached --quiet; then
        echo "没有变更，跳过提交"
    else
        git commit -m "sync v210 update"
        git push origin main
    fi
    ./deploy.sh
else
    echo "已跳过发布。准备好后请运行 ./deploy.sh"
fi
