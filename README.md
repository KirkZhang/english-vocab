# 英语背单词 PWA

上海高中 + 初中英语背单词,可「添加到主屏」当 app 用、离线可用。

## 在线访问(GitHub Pages)

- 高中版:https://KirkZhang.github.io/english-vocab/
- 初中版:https://KirkZhang.github.io/english-vocab/zhongkao/

## 添加到主屏

**iPhone / iPad(Safari)**:打开网址 → 底部「分享」→「添加到主屏幕」→ 桌面图标点开即全屏离线运行。

**Android(Chrome)**:打开网址 → 地址栏「安装」提示,或菜单「添加到主屏幕」。

## 本地预览

```bash
cd /Volumes/Data/temp/HighSchEng
python3 -m http.server 8000
# 高中:http://localhost:8000/   初中:http://localhost:8000/zhongkao/
```

> 注意:`file://` 双击打开无法注册 Service Worker,PWA 功能需 `localhost` 或 `https`。

## 部署 / 更新

```bash
./deploy.sh                 # 默认仓库名 english-vocab
./deploy.sh my-vocab-repo   # 自定义仓库名
```

脚本会:同步初中版成品 → git 提交 → 推送 → 启用 GitHub Pages。首次推送后等 1-2 分钟 Pages 生效。

## 仓库结构

```
index.html  manifest.json  sw.js  icon-*.png   高中版 PWA
zhongkao/                                    初中版 PWA(同结构)
```

源项目(词表 / 例句生成流水线 / docx)不在此仓库,仅放部署产物。
