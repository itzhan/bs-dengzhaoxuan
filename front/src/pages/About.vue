<template>
  <section class="section">
    <h2 class="section-title">关于平台</h2>
    <p class="section-subtitle">为农产品产销对接提供可信、高效、可视化的公共展示平台。</p>

    <a-row :gutter="20">
      <a-col :xs="24" :md="12">
        <div class="card-surface" style="padding: 22px; height: 100%;">
          <h3 class="section-title" style="font-size: 24px;">使命与价值</h3>
          <p class="card-desc">
            平台致力于解决农产品流通中信息不对称、交易链条冗长、履约成本高等问题，
            通过数字化工具实现"供需可见、履约可控、溯源可信"。
          </p>
          <div class="badge-row" style="margin-top: 16px;">
            <a-tag color="green">产地直采</a-tag>
            <a-tag color="arcoblue">数据驱动</a-tag>
            <a-tag color="gold">品质可信</a-tag>
            <a-tag color="lime">履约保障</a-tag>
          </div>
        </div>
      </a-col>
      <a-col :xs="24" :md="12">
        <div class="card-surface" style="padding: 22px; height: 100%;">
          <h3 class="section-title" style="font-size: 24px;">服务对象</h3>
          <div class="soft-panel">
            <div class="card-title">生产方</div>
            <p class="card-desc">提供产地供应信息、库存与履约能力展示。</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">采购方</div>
            <p class="card-desc">公开需求计划、查看供应与履约保障。</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">政府与行业机构</div>
            <p class="card-desc">获取产销监测数据，掌握市场趋势。</p>
          </div>
        </div>
      </a-col>
    </a-row>

    <a-row :gutter="20">
      <a-col :xs="24" :md="12">
        <a-card title="平台能力" :bordered="false" class="card-surface" style="height: 100%;">
          <div class="soft-panel">
            <div class="card-title">供需撮合</div>
            <p class="card-desc">按品类、产地、规模与履约能力推荐最优交易对象。</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">订单履约</div>
            <p class="card-desc">订单状态、物流节点、温控数据全程可视。</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">溯源与品质</div>
            <p class="card-desc">二维码溯源覆盖采收、质检、仓储与配送。</p>
          </div>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="12">
        <a-card title="联系我们" :bordered="false" class="card-surface" style="height: 100%;">
          <div class="soft-panel">
            <div class="card-title">平台服务中心</div>
            <p class="card-desc">河南省郑州市农业数字化中心</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">服务电话</div>
            <p class="card-desc">400-888-2868</p>
          </div>
          <div class="soft-panel">
            <div class="card-title">服务邮箱</div>
            <p class="card-desc">service@agri-bridge.cn</p>
          </div>
        </a-card>
      </a-col>
    </a-row>
  </section>
</template>
