export const coreFlow = [
  {
    title: '供需发布',
    desc: '生产方发布供应计划，采购方提交求购需求，信息全程透明。',
    icon: 'icon-file'
  },
  {
    title: '智能撮合',
    desc: '基于品类、产地、数量和履约能力快速匹配最优交易。',
    icon: 'icon-apps'
  },
  {
    title: '订单协同',
    desc: '订单、质检、物流节点全流程可视化，降低沟通成本。',
    icon: 'icon-swap'
  },
  {
    title: '溯源信任',
    desc: '二维码追溯产地、采收、检验与运输记录，保障品质。',
    icon: 'icon-safe'
  }
]

// 平台能力亮点：使用具象指标 + 进度/趋势，解决原先描述空泛的问题
export const platformHighlights = [
  {
    title: '产销数据驾驶舱',
    icon: 'icon-dashboard',
    color: '#2b8a57',
    value: 86.4,
    unit: '%',
    metricLabel: '数据覆盖率',
    trend: '+4.2%',
    trendUp: true,
    progress: 86,
    desc: '覆盖交易量、品类结构、区域供给热度，为决策提供依据。',
    tags: ['实时看板', 'BI 导出', '区域对比']
  },
  {
    title: '冷链履约保障',
    icon: 'icon-common',
    color: '#1677ff',
    value: 96.4,
    unit: '%',
    metricLabel: '冷链履约率',
    trend: '+1.8%',
    trendUp: true,
    progress: 96,
    desc: '对接冷链车队与仓储资源，实现全程温控与时效管理。',
    tags: ['温控 ±1℃', '平均 4h 送达', 'GPS 轨迹']
  },
  {
    title: '可信资质核验',
    icon: 'icon-check-circle',
    color: '#f59e0b',
    value: 92,
    unit: '%',
    metricLabel: '资质通过率',
    trend: '+0.6%',
    trendUp: true,
    progress: 92,
    desc: '生产基地、合作社、采购机构资质上链审核，交易更安心。',
    tags: ['营业执照', '种植证', '检测报告']
  },
  {
    title: '供销协同社区',
    icon: 'icon-fire',
    color: '#d63e3e',
    value: 12800,
    unit: '+',
    metricLabel: '活跃用户',
    trend: '+12.5%',
    trendUp: true,
    progress: 78,
    desc: '开放行情、政策与培训内容，持续提升农产品流通效率。',
    tags: ['每周行情', '政策速递', '线上培训']
  }
]

export const quickInsights = [
  '苹果、红薯、番茄进入本周供给高峰',
  '冷链履约率提升至 96.4%',
  '采购端需求集中在华中与华东区域',
  '产地认证通过率保持在 92%'
]
