# 要约 / THE OFFER — Clean Repository

这是《要约》游戏的干净发布仓库，只包含实际运行所需的文件。

当前基于版本：**v210**

## 文件说明

- `index.html`：游戏主入口
- `final/`：所有外部素材（卡牌、背景、音效、配音等）
- 根目录其他文件：`grok/` 本地依赖资源

## 本地预览

直接双击 `index.html`，或用本地服务器：

```bash
python3 -m http.server 8080
# 然后访问 http://localhost:8080
```

## 部署到 Cloudflare Pages

```bash
./deploy.sh
# 或
npx wrangler pages deploy . --project-name the-offer-oli
```

## 推到 GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/the-offer.git
git branch -M main
git push -u origin main
```
