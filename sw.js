// Service Worker —— 高中版背单词 PWA 离线缓存
// 预缓存核心资源(相对路径,适配 GitHub Pages 子路径),缓存优先,回退网络。
const CACHE = 'vocab-gz-v2';
const CORE = [
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
  './icon-maskable-512.png',
  './apple-touch-icon.png'
];

self.addEventListener('install', e => {
  e.waitUntil((async () => {
    const c = await caches.open(CACHE);
    await c.addAll(CORE);
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', e => {
  e.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  e.respondWith((async () => {
    const hit = await caches.match(req);
    if (hit) return hit;                       // 缓存优先
    try {
      const resp = await fetch(req);
      if (resp.ok && resp.type === 'basic') {  // 同源资源顺带缓存
        const copy = resp.clone();
        const c = await caches.open(CACHE);
        c.put(req, copy);
      }
      return resp;
    } catch (err) {
      const fallback = await caches.match('./index.html');
      if (fallback) return fallback;           // 离线回退到主页
      throw err;
    }
  })());
});
