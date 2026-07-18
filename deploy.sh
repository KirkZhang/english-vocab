#!/usr/bin/env bash
# 一键部署/更新背单词 PWA 到 GitHub Pages。
# 用法: ./deploy.sh [仓库名]    默认仓库名 english-vocab
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"          # = HighSchEng 仓库根
REPO="${1:-english-vocab}"
cd "$ROOT"

echo "== 1. 同步初中版成品 -> zhongkao/ =="
ZK_SRC="$(cd "$ROOT/../zhongkao" 2>/dev/null && pwd)" || ZK_SRC=""
if [ -n "$ZK_SRC" ] && [ -f "$ZK_SRC/index.html" ]; then
  mkdir -p zhongkao
  for f in index.html manifest.json sw.js; do
    [ -f "$ZK_SRC/$f" ] && cp "$ZK_SRC/$f" zhongkao/
  done
  cp "$ZK_SRC"/icon-*.png "$ZK_SRC"/apple-touch-icon.png zhongkao/ 2>/dev/null || true
  echo "   已从 $ZK_SRC 同步"
else
  echo "   (未找到初中版源 $ROOT/../zhongkao,跳过)"
fi

echo "== 2. git 提交 =="
if [ ! -d .git ]; then
  git init -q
  git branch -M main
fi
git add -A
git commit -q -m "deploy: update PWA $(date +%Y-%m-%d)" || echo "   无变更可提交"

echo "== 3. 创建/推送远程仓库 =="
if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$REPO" --public --source=. --remote=origin --push
else
  git push origin main
fi

echo "== 4. 启用 GitHub Pages(main / 根) =="
gh api -X POST "/repos/:owner/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  && echo "   Pages 已启用" \
  || echo "   (Pages 可能已启用或需手动:仓库 Settings → Pages → Source: main / root)"

echo ""
echo "✅ 完成! 等 1-2 分钟后访问:"
echo "   高中: https://$(gh api user --jq .login).github.io/$REPO/"
echo "   初中: https://$(gh api user --jq .login).github.io/$REPO/zhongkao/"
