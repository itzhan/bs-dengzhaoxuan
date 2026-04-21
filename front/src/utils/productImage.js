// 农产品图片工具：为未配置 imageUrl 的商品生成主题兜底图
// 按关键词匹配多张内置 SVG 图；完全无匹配则用品名 + 渐变色占位。

const KEYWORD_IMAGES = [
  { keys: ['苹果', 'apple'], emoji: '🍎', color: '#e74c3c' },
  { keys: ['番茄', '西红柿', 'tomato'], emoji: '🍅', color: '#e14b4b' },
  { keys: ['红薯', '地瓜', 'sweet'], emoji: '🍠', color: '#b56b3a' },
  { keys: ['玉米', 'corn'], emoji: '🌽', color: '#e9b824' },
  { keys: ['葡萄', 'grape'], emoji: '🍇', color: '#7b3fa6' },
  { keys: ['草莓', 'strawberry'], emoji: '🍓', color: '#e63946' },
  { keys: ['西瓜', 'watermelon'], emoji: '🍉', color: '#2fa34f' },
  { keys: ['橙', '橘', 'orange'], emoji: '🍊', color: '#ff8c33' },
  { keys: ['香蕉', 'banana'], emoji: '🍌', color: '#f1c40f' },
  { keys: ['胡萝卜', '萝卜', 'carrot'], emoji: '🥕', color: '#e67e22' },
  { keys: ['茄子', 'eggplant'], emoji: '🍆', color: '#6c3483' },
  { keys: ['辣椒', 'pepper', 'chili'], emoji: '🌶️', color: '#c0392b' },
  { keys: ['白菜', '青菜', 'cabbage'], emoji: '🥬', color: '#3fa34f' },
  { keys: ['土豆', '马铃薯', 'potato'], emoji: '🥔', color: '#c08457' },
  { keys: ['麦', '稻', '米', 'rice', 'wheat'], emoji: '🌾', color: '#c9a227' },
  { keys: ['鸡蛋', 'egg'], emoji: '🥚', color: '#e8c170' },
  { keys: ['牛奶', 'milk'], emoji: '🥛', color: '#8fb8de' },
  { keys: ['茶', 'tea'], emoji: '🍵', color: '#2b8a57' },
  { keys: ['菌', '蘑菇', 'mushroom'], emoji: '🍄', color: '#a0522d' },
  { keys: ['鱼', 'fish'], emoji: '🐟', color: '#1f77b4' }
]

const DEFAULT_THEME = { emoji: '🌿', color: '#2b8a57' }

const themeFor = (name = '') => {
  const lower = String(name).toLowerCase()
  for (const entry of KEYWORD_IMAGES) {
    if (entry.keys.some((k) => lower.includes(k.toLowerCase()))) {
      return entry
    }
  }
  return DEFAULT_THEME
}

const escapeXml = (str = '') =>
  String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')

export const productFallbackImage = (name = '农产品') => {
  const theme = themeFor(name)
  const label = escapeXml(name).slice(0, 12)
  const lighter = `${theme.color}22`
  const svg = `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="240" viewBox="0 0 400 240">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${theme.color}"/>
      <stop offset="100%" stop-color="${lighter}"/>
    </linearGradient>
  </defs>
  <rect width="400" height="240" fill="url(#g)"/>
  <circle cx="320" cy="60" r="70" fill="#ffffff22"/>
  <circle cx="60" cy="200" r="90" fill="#ffffff18"/>
  <text x="50%" y="52%" font-size="110" text-anchor="middle" dominant-baseline="middle">${theme.emoji}</text>
  <text x="50%" y="88%" font-size="22" font-weight="700" fill="#ffffff" text-anchor="middle" font-family="PingFang SC, Helvetica, Arial">${label}</text>
</svg>`
  return `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`
}

export const productImageFor = (product) => {
  if (product?.imageUrl) return product.imageUrl
  return productFallbackImage(product?.name || '农产品')
}
