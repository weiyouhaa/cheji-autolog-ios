// 车记 (AutoLog) — iOS 27 "Liquid Glass" Vehicle Lifecycle App Controller

const VEHICLES = {
  bmw330: {
    id: "bmw330",
    name: "BMW 330Li 曜夜",
    fullName: "2024款 BMW 330Li M运动曜夜套装",
    plate: "沪A·889M3",
    isEV: false,
    energyType: "95# 汽油",
    vin: "LBV8A510XRM089241",
    engineNo: "B48B20G-8821",
    colorName: "布鲁克林灰 / 红内",
    purchaseDate: "2024-03-18",
    daysOwned: 602,
    odometer: 24860,
    dailyKm: 41.3,
    avgConsumption: 7.92,
    consumptionUnit: "L/100km",
    energyCostPerKm: 0.63,
    totalFuelSpend: 15662,
    totalMaintSpend: 4820,
    totalInsuranceSpend: 15450,
    totalOtherSpend: 6430,
    purchase: {
      nakedPrice: 318000,
      tax: 28142,
      firstInsurance: 8650,
      regAndPlate: 500,
      accessories: 9300,
      totalLanded: 364592,
      estimatedResale: 266000,
      dealer: "上海宝诚宝马 4S 中心",
      loanStatus: "已结清 (全款购置)"
    },
    healthScore: 94,
    nextAlert: "四轮动平衡与换位 · 剩余 840 km",
    fuelLogs: [
      { date: "11-06", odo: 24860, deltaKm: 562, volume: 43.8, price: 7.96, cost: 348.6, consumption: 7.79, station: "壳牌 V-Power 世纪大道站", full: true, note: "95# 满箱跳枪 · 高架顺畅" },
      { date: "10-22", odo: 24298, deltaKm: 518, volume: 42.1, price: 7.96, cost: 335.1, consumption: 8.13, station: "中石化 延安西路站", full: true, note: "95# 满箱跳枪 · 市区通勤" },
      { date: "10-07", odo: 23780, deltaKm: 590, volume: 44.5, price: 7.85, cost: 349.3, consumption: 7.54, station: "中石油 嘉松中路站", full: true, note: "95# 满箱跳枪 · 莫干山自驾" },
      { date: "09-21", odo: 23190, deltaKm: 504, volume: 41.2, price: 7.85, cost: 323.4, consumption: 8.17, station: "壳牌 浦东锦绣路站", full: true, note: "95# 满箱跳枪 · 全程空调" },
      { date: "09-05", odo: 22686, deltaKm: 535, volume: 42.0, price: 8.02, cost: 336.8, consumption: 7.85, station: "中石化 龙东大道站", full: true, note: "95# 满箱跳枪 · 常规通勤" }
    ],
    maintenanceParts: [
      { name: "四轮换位 & 动平衡", spec: "米其林 PS4 防爆胎", usedKm: 9160, limitKm: 10000, usedDays: 260, limitDays: 365, pct: 16, estCost: 180, lastDate: "2026-02-22 @ 15,700km" },
      { name: "全合成机油 + 机滤", spec: "BMW 原厂 0W-20 LL-17FE+", usedKm: 4860, limitKm: 10000, usedDays: 142, limitDays: 365, pct: 52, estCost: 1180, lastDate: "2026-06-20 @ 20,000km" },
      { name: "空调活性碳滤芯", spec: "曼牌 CUK 23014 抗菌型", usedKm: 4860, limitKm: 15000, usedDays: 142, limitDays: 365, pct: 68, estCost: 360, lastDate: "2026-06-20 @ 20,000km" },
      { name: "NGK 铱铂金火花塞 (4支)", spec: "B48 专用 SILZKGR8B8S", usedKm: 4860, limitKm: 40000, usedDays: 142, limitDays: 1095, pct: 88, estCost: 960, lastDate: "2026-06-20 @ 20,000km" },
      { name: "DOT4 低粘度制动液", spec: "博世 ENV6 刹车油", usedKm: 24860, limitKm: 40000, usedDays: 602, limitDays: 730, pct: 24, estCost: 420, lastDate: "出厂初装 (建议满2年更换)" }
    ],
    serviceRecords: [
      { date: "2026-06-20", type: "二保 · 2万公里大保养", shop: "上海宝诚宝马 4S", odo: 20000, cost: 2680, items: ["0W-20机油机滤", "火花塞×4", "空调滤芯", "全车电脑诊断"] },
      { date: "2025-11-12", type: "右后胎扎钉蘑菇钉补胎", shop: "途虎养车工场店 (联洋)", odo: 14200, cost: 120, items: ["米其林内补蘑菇钉", "右后轮动平衡"] },
      { date: "2025-01-18", type: "首保 · 1万公里常规保养", shop: "上海宝诚宝马 4S", odo: 10120, cost: 1180, items: ["0W-20全合成机油", "原厂机油滤清器", "底盘螺栓复紧"] }
    ],
    insurance: {
      company: "中国平安产险 · 尊享车险",
      policyNo: "PAIC-2026-310115-88291",
      expireDate: "2027-03-17",
      daysRemaining: 128,
      ncdFactor: "0.70 (连续2年未出险)",
      totalPremium: 6800,
      compulsory: 855,
      commercial: 5945,
      coverages: [
        { name: "机动车损失险 (车损)", amount: "¥278,400", premium: "¥3,820" },
        { name: "第三者责任险", amount: "¥3,000,000", premium: "¥1,680" },
        { name: "医保外医疗费用责任险", amount: "¥100,000", premium: "¥165" },
        { name: "车上人员责任险 (司/乘)", amount: "¥100,000/座", premium: "¥280" },
        { name: "道路救援服务", amount: "全年无限次 100km", premium: "赠送" }
      ],
      compliance: {
        inspectionExpire: "2028-03-31 (6年免检·第4年申领电子标)",
        violations: "0 条未处理 · 驾驶证 12 分满分",
        etcCard: "沪通卡 ETC · 本月通行 ¥185.00"
      }
    },
    timeline: [
      { date: "2026-11-06", cat: "加油", color: "amber", title: "壳牌 V-Power 95# 满箱加注", cost: "-¥348.6", odo: "24,860 km", tags: ["43.80 L", "实测油耗 7.79L/百公里", "单价 ¥7.96"] },
      { date: "2026-06-20", cat: "保养", color: "blue", title: "20,000 km 4S店定期大保养", cost: "-¥2,680.0", odo: "20,000 km", tags: ["机油机滤", "火花塞×4", "空调滤", "发票已存"] },
      { date: "2026-03-15", cat: "保险", color: "emerald", title: "第3年车险续保 (平安车险 NCD 0.7)", cost: "-¥6,800.0", odo: "16,800 km", tags: ["交强险 ¥855", "300万三者+车损 ¥5,945", "赠2次代驾"] },
      { date: "2025-11-12", cat: "维修", color: "rose", title: "右后轮扎钉 · 蘑菇钉内补+动平衡", cost: "-¥120.0", odo: "14,200 km", tags: ["途虎工场店", "胎压恢复 2.5 Bar"] },
      { date: "2024-03-22", cat: "上路", color: "purple", title: "车管所选号上牌 & 贴XPEL隐形车衣", cost: "-¥9,800.0", odo: "128 km", tags: ["沪A·889M3", "行驶证大绿本归档", "ETC激活"] },
      { date: "2024-03-18", cat: "买车", color: "purple", title: "提车交付 · 2024款 BMW 330Li 曜夜", cost: "-¥354,792", odo: "12 km", tags: ["裸车 ¥31.8万", "购置税 ¥28,142", "首保险 ¥8,650"] }
    ]
  },

  nioEt5t: {
    id: "nioEt5t",
    name: "蔚来 ET5T 75kWh",
    fullName: "2025款 NIO ET5T Touring 智能电动旅行车",
    plate: "沪AD·61920",
    isEV: true,
    energyType: "纯电 / 换电",
    vin: "LJ1EFAUU5RG061920",
    engineNo: "EDS-360kW-Dual",
    colorName: "云初黄 / 珍珠贝内饰",
    purchaseDate: "2025-01-12",
    daysOwned: 302,
    odometer: 16420,
    dailyKm: 54.4,
    avgConsumption: 14.8,
    consumptionUnit: "kWh/100km",
    energyCostPerKm: 0.14,
    totalFuelSpend: 2298,
    totalMaintSpend: 980,
    totalInsuranceSpend: 7420,
    totalOtherSpend: 3820,
    purchase: {
      nakedPrice: 266000,
      tax: 0,
      firstInsurance: 7420,
      regAndPlate: 120,
      accessories: 6380,
      totalLanded: 279920,
      estimatedResale: 218000,
      dealer: "蔚来中心 NIO House 上海中心",
      loanStatus: "整车买断 (免购置税)"
    },
    healthScore: 98,
    nextAlert: "2万公里常规健检 · 剩余 3,580 km",
    fuelLogs: [
      { date: "11-08", odo: 16420, deltaKm: 412, volume: 61.5, price: 0.92, cost: 56.6, consumption: 14.9, station: "蔚来三代换电站 · 漕河泾", full: true, note: "3分钟极速满电换电" },
      { date: "10-29", odo: 16008, deltaKm: 430, volume: 62.0, price: 0.36, cost: 22.3, consumption: 14.4, station: "地下车库 7kW 家充桩 (谷电)", full: true, note: "22:00后谷电 0.36元/度" },
      { date: "10-16", odo: 15578, deltaKm: 395, volume: 59.8, price: 0.36, cost: 21.5, consumption: 15.1, station: "地下车库 7kW 家充桩 (谷电)", full: true, note: "周末安吉露营满载" },
      { date: "10-03", odo: 15183, deltaKm: 440, volume: 63.4, price: 1.15, cost: 72.9, consumption: 14.4, station: "蔚来 500kW 超充桩 · 嘉兴服务区", full: true, note: "高速 NOP+ 领航辅助" }
    ],
    maintenanceParts: [
      { name: "CN95 抗菌空调滤芯", spec: "原厂 HEPA 活性炭滤网", usedKm: 6420, limitKm: 15000, usedDays: 160, limitDays: 365, pct: 57, estCost: 280, lastDate: "2026-06-01 @ 10,000km" },
      { name: "雨刮胶条 (前风挡+后掀背)", spec: "博世静音无骨雨刮", usedKm: 16420, limitKm: 20000, usedDays: 302, limitDays: 365, pct: 18, estCost: 190, lastDate: "出厂初装" },
      { name: "前后减速器齿轮油", spec: "电驱专用低阻齿轮油", usedKm: 16420, limitKm: 60000, usedDays: 302, limitDays: 1095, pct: 73, estCost: 680, lastDate: "出厂初装" },
      { name: "马牌 EcoContact 6 静音胎", spec: "245/45 R19 自修复轮胎", usedKm: 16420, limitKm: 45000, usedDays: 302, limitDays: 1095, pct: 64, estCost: 1350, lastDate: "胎纹深度 6.2mm" }
    ],
    serviceRecords: [
      { date: "2026-06-01", type: "10,000 km 年度无忧健检", shop: "蔚来服务中心 (上海莘庄)", odo: 10000, cost: 580, items: ["空调滤芯更换", "三电高压系统检测", "四轮定位校准"] }
    ],
    insurance: {
      company: "太平洋新能源车险 · 智驾版",
      policyNo: "CPIC-EV-2026-099120",
      expireDate: "2027-01-11",
      daysRemaining: 62,
      ncdFactor: "0.85 (首年无出险优待)",
      totalPremium: 6420,
      compulsory: 950,
      commercial: 5470,
      coverages: [
        { name: "新能源汽车损失险 (含三电)", amount: "¥232,000", premium: "¥3,480" },
        { name: "第三者责任险", amount: "¥3,000,000", premium: "¥1,590" },
        { name: "外部电网故障损失险", amount: "含家充桩保障", premium: "¥180" },
        { name: "智能辅助泊车责任保障", amount: "¥50,000", premium: "¥220" }
      ],
      compliance: {
        inspectionExpire: "2027-01-31 (绿牌免检申领)",
        violations: "0 条未处理 · 驾驶证 12 分满分",
        etcCard: "沪通卡新能源 ETC · 95折通行"
      }
    },
    timeline: [
      { date: "2026-11-08", cat: "加油", color: "emerald", title: "蔚来三代站极速换电 61.5 kWh", cost: "-¥56.6", odo: "16,420 km", tags: ["3分钟换电", "电耗 14.9kWh", "电池健康 100%"] },
      { date: "2026-06-01", cat: "保养", color: "blue", title: "1万公里三电健检 & 空调滤更换", cost: "-¥580.0", odo: "10,000 km", tags: ["蔚来服务中心", "三电满分", "取送车服务"] },
      { date: "2025-01-15", cat: "上路", color: "purple", title: "新能源绿牌上牌 & Thule车顶箱安装", cost: "-¥6,500.0", odo: "65 km", tags: ["沪AD·61920", "免征购置税", "家充桩报装完工"] },
      { date: "2025-01-12", cat: "买车", color: "purple", title: "提车交付 · 蔚来 ET5T Touring", cost: "-¥273,420", odo: "8 km", tags: ["整车 ¥26.6万", "购置税 ¥0", "首年保险 ¥7,420"] }
    ]
  }
};

// App State & Category-Specific Form States
let state = {
  currentVehicleId: "bmw330",
  currentTab: "cockpit",
  theme: "dark",
  studioMode: "interactive",
  quickLogOpen: false,
  quickLogCat: "加油",
  lifecycleFilter: "all",

  // Sub-options per category in Quick Log Sheet
  fuelSubType: "95# 汽油",
  fuelFullTank: true,
  maintShopType: "品牌 4S 中心",
  maintCheckedParts: [0, 1], // indices of checked maintenance parts
  repairPartArea: "🛞 轮胎/轮毂",
  repairClaimType: "💳 自费维修",
  insCompany: "🛡️ 中国平安车险",
  insCheckedItems: [0, 1, 2, 3],
  roadExpenseType: "🅿️ 停车费/月租",
  modSubType: "🛡️ 隐形车衣/改色膜"
};

function getCar() {
  return VEHICLES[state.currentVehicleId];
}

function formatMoney(n) {
  return "¥" + Number(n).toLocaleString("zh-CN");
}

// ==========================================
// SVG CAR SILHOUETTES
// ==========================================
function renderCarSvg(isEV) {
  if (!isEV) {
    return `
      <svg width="260" height="78" viewBox="0 0 260 78" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="carBodyGrad" x1="20" y1="15" x2="240" y2="65" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#94a3b8"/>
            <stop offset="45%" stop-color="#f1f5f9"/>
            <stop offset="100%" stop-color="#475569"/>
          </linearGradient>
          <linearGradient id="windowGrad" x1="70" y1="18" x2="180" y2="38" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#1e293b"/>
            <stop offset="100%" stop-color="#0f172a"/>
          </linearGradient>
        </defs>
        <ellipse cx="130" cy="67" rx="108" ry="6" fill="rgba(0,0,0,0.55)"/>
        <path d="M22 50 C24 41, 34 36, 56 34 L88 18 C102 14, 152 14, 174 20 L204 33 C224 35, 236 40, 238 49 L236 57 C234 60, 224 61, 214 61 L44 61 C30 61, 22 58, 22 50 Z" fill="url(#carBodyGrad)" stroke="rgba(255,255,255,0.45)" stroke-width="1.2"/>
        <path d="M64 33 L91 20 C104 16.5, 148 16.5, 168 21.5 L191 33 Z" fill="url(#windowGrad)" stroke="rgba(255,255,255,0.25)" stroke-width="1"/>
        <line x1="128" y1="17.5" x2="124" y2="33" stroke="rgba(255,255,255,0.22)" stroke-width="1.5"/>
        <path d="M24 45 L38 43 L35 48 L23 49 Z" fill="#38bdf8" filter="drop-shadow(0 0 6px #38bdf8)"/>
        <path d="M226 41 L237 43 L236 48 L224 46 Z" fill="#ff4d2d" filter="drop-shadow(0 0 6px #ff4d2d)"/>
        <path d="M40 48 L195 45" stroke="rgba(255,94,43,0.75)" stroke-width="1.5" stroke-linecap="round"/>
        <circle cx="64" cy="57" r="15" fill="#0f172a" stroke="#334155" stroke-width="2.5"/>
        <circle cx="64" cy="57" r="9" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 3"/>
        <circle cx="64" cy="57" r="3.5" fill="#ff5a26"/>
        <circle cx="194" cy="57" r="15" fill="#0f172a" stroke="#334155" stroke-width="2.5"/>
        <circle cx="194" cy="57" r="9" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="4 3"/>
        <circle cx="194" cy="57" r="3.5" fill="#ff5a26"/>
      </svg>
    `;
  } else {
    return `
      <svg width="260" height="78" viewBox="0 0 260 78" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="evBodyGrad" x1="20" y1="15" x2="240" y2="65" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#fde047"/>
            <stop offset="55%" stop-color="#facc15"/>
            <stop offset="100%" stop-color="#ca8a04"/>
          </linearGradient>
        </defs>
        <ellipse cx="130" cy="67" rx="108" ry="6" fill="rgba(0,0,0,0.55)"/>
        <rect x="108" y="10" width="64" height="5" rx="2.5" fill="#334155" stroke="rgba(255,255,255,0.3)" stroke-width="0.8"/>
        <path d="M22 50 C25 40, 38 35, 60 33 L94 17 C116 14, 182 14, 212 22 L232 36 C237 41, 238 48, 236 56 C234 60, 222 61, 212 61 L42 61 C28 61, 22 57, 22 50 Z" fill="url(#evBodyGrad)" stroke="rgba(255,255,255,0.45)" stroke-width="1.2"/>
        <path d="M68 32 L96 19 C118 16, 178 16, 204 23 L219 33 Z" fill="#0f172a" stroke="rgba(255,255,255,0.25)" stroke-width="1"/>
        <path d="M24 44 L39 42 L36 46 L23 47 Z" fill="#38bdf8" filter="drop-shadow(0 0 6px #38bdf8)"/>
        <path d="M220 39 L236 41 L235 45 L219 43 Z" fill="#f43f5e" filter="drop-shadow(0 0 6px #f43f5e)"/>
        <circle cx="64" cy="57" r="15" fill="#0f172a" stroke="#334155" stroke-width="2.5"/>
        <circle cx="64" cy="57" r="9" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-dasharray="5 3"/>
        <circle cx="64" cy="57" r="3.5" fill="#10b981"/>
        <circle cx="194" cy="57" r="15" fill="#0f172a" stroke="#334155" stroke-width="2.5"/>
        <circle cx="194" cy="57" r="9" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-dasharray="5 3"/>
        <circle cx="194" cy="57" r="3.5" fill="#10b981"/>
      </svg>
    `;
  }
}

// ==========================================
// SCREEN 1: COCKPIT HOME (爱车中枢首页)
// ==========================================
function buildCockpitScreen(car) {
  const totalCostAll = car.purchase.totalLanded + car.totalFuelSpend + car.totalMaintSpend + car.totalInsuranceSpend - car.purchase.firstInsurance + car.totalOtherSpend;
  const netHoldingCost = totalCostAll - car.purchase.estimatedResale;
  const dailyHoldingCost = (netHoldingCost / car.daysOwned).toFixed(1);

  return `
    <!-- Hero Vehicle Liquid Glass Card -->
    <div class="ios-card hero-vehicle-card">
      <div class="hero-top-row">
        <div>
          <div class="hero-car-title">${car.name}</div>
          <div class="hero-car-sub">
            <span>${car.colorName}</span>
            <span>·</span>
            <span>陪伴 ${car.daysOwned} 天</span>
          </div>
        </div>
        <span class="status-chip chip-emerald">
          <span style="width:6px;height:6px;border-radius:50%;background:#34d399;"></span>
          车况 ${car.healthScore}分
        </span>
      </div>

      <div class="hero-car-visual">
        <div class="hero-car-glow"></div>
        ${renderCarSvg(car.isEV)}
      </div>

      <div class="odometer-strip">
        <div class="odo-left">
          <span class="odo-label">总行驶里程 ODOMETER</span>
          <div class="odo-digits tabular-nums">
            <span class="odo-number">${car.odometer.toLocaleString()}</span>
            <span class="odo-unit">km</span>
          </div>
        </div>
        <div class="odo-right tabular-nums">
          <div class="odo-sub-stat">日均 ${car.dailyKm} km</div>
          <div class="odo-sub-desc">全周期 ¥${dailyHoldingCost}/天 (含折旧)</div>
        </div>
      </div>
    </div>

    <!-- 2x2 Liquid Glass Telemetry Bento Grid -->
    <div class="bento-grid-2x2">
      <div class="bento-tile" onclick="switchTab('fuel')">
        <div class="bento-top">
          <div class="bento-icon" style="background:var(--accent-amber-soft);color:var(--accent-amber);">⛽</div>
          <span class="bento-tag" style="background:var(--accent-emerald-soft);color:var(--accent-emerald);">优于同系 12%</span>
        </div>
        <div class="bento-value tabular-nums">
          ${car.avgConsumption}<span class="bento-unit">${car.consumptionUnit}</span>
        </div>
        <div class="bento-label">${car.isEV ? "实测综合百公里电耗" : "实测满箱百公里油耗"}</div>
        <div class="bento-foot tabular-nums">
          <span>折合 ¥${car.energyCostPerKm}/km</span>
          <span>曲线 ›</span>
        </div>
      </div>

      <div class="bento-tile" onclick="switchTab('maintenance')">
        <div class="bento-top">
          <div class="bento-icon" style="background:var(--accent-blue-soft);color:var(--accent-blue);">🔧</div>
          <span class="bento-tag" style="background:var(--accent-amber-soft);color:var(--accent-amber);">寿命监控</span>
        </div>
        <div class="bento-value tabular-nums">
          ${car.isEV ? "3,580" : "840"}<span class="bento-unit">km后</span>
        </div>
        <div class="bento-label">${car.isEV ? "下次常规三电健检" : "四轮换位 & 动平衡"}</div>
        <div class="progress-track">
          <div class="progress-fill" style="width:${car.isEV ? "65%" : "86%"};background:var(--accent-amber);"></div>
        </div>
      </div>

      <div class="bento-tile" onclick="switchTab('insurance')">
        <div class="bento-top">
          <div class="bento-icon" style="background:var(--accent-emerald-soft);color:var(--accent-emerald);">🛡️</div>
          <span class="bento-tag" style="background:var(--accent-blue-soft);color:var(--accent-blue);">0 违章</span>
        </div>
        <div class="bento-value tabular-nums">
          ${car.insurance.daysRemaining}<span class="bento-unit">天到期</span>
        </div>
        <div class="bento-label">${car.insurance.company.split("·")[0]}</div>
        <div class="bento-foot tabular-nums">
          <span>${car.insurance.ncdFactor.split(" ")[0]} 折扣</span>
          <span>保单 ›</span>
        </div>
      </div>

      <div class="bento-tile" onclick="switchTab('lifecycle')">
        <div class="bento-top">
          <div class="bento-icon" style="background:var(--accent-purple-soft);color:var(--accent-purple);">📊</div>
          <span class="bento-tag" style="background:var(--accent-purple-soft);color:var(--accent-purple);">残值 ${(car.purchase.estimatedResale/10000).toFixed(1)}万</span>
        </div>
        <div class="bento-value tabular-nums">
          ¥${( (car.totalFuelSpend + car.totalMaintSpend + car.totalInsuranceSpend + car.totalOtherSpend) / 10000 ).toFixed(2)}<span class="bento-unit">万</span>
        </div>
        <div class="bento-label">累计养车支出 (不含购车)</div>
        <div class="bento-foot tabular-nums">
          <span>落地 ¥${(car.purchase.totalLanded/10000).toFixed(1)}万</span>
          <span>TCO ›</span>
        </div>
      </div>
    </div>

    <!-- Recent Lifecycle Stream Preview -->
    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">
          <span>⏱️ 最近车务动态</span>
        </div>
        <button class="ios-card-link" onclick="switchTab('lifecycle')">全周期 (${car.timeline.length}) ›</button>
      </div>
      <div class="timeline-list">
        ${car.timeline.slice(0, 3).map(item => renderTimelineNode(item)).join("")}
      </div>
    </div>
  `;
}

function renderTimelineNode(item) {
  const dotColors = {
    amber: "#fbbf24",
    blue: "#38bdf8",
    emerald: "#34d399",
    rose: "#fb7185",
    purple: "#c084fc"
  };
  const c = dotColors[item.color] || "#ff5e2b";
  return `
    <div class="timeline-node">
      <div class="timeline-dot" style="background:${c};box-shadow:0 0 8px ${c};"></div>
      <div class="timeline-card-inner">
        <div class="timeline-row-top">
          <span class="timeline-title">${item.title}</span>
          <span class="timeline-cost tabular-nums">${item.cost}</span>
        </div>
        <div class="timeline-meta tabular-nums">
          <span>📅 ${item.date}</span>
          <span>·</span>
          <span>🛣️ ${item.odo}</span>
          <span>·</span>
          <span style="color:${c};font-weight:700;">#${item.cat}</span>
        </div>
        <div class="timeline-badges">
          ${item.tags.map(t => `<span class="micro-tag">${t}</span>`).join("")}
        </div>
      </div>
    </div>
  `;
}

// ==========================================
// SCREEN 2: LIFECYCLE & PURCHASE (买车·上路·全周期时间轴)
// ==========================================
function buildLifecycleScreen(car) {
  const runningCosts = car.totalFuelSpend + car.totalMaintSpend + car.totalInsuranceSpend + car.totalOtherSpend;
  const depreciation = car.purchase.totalLanded - car.purchase.estimatedResale;

  const filteredTimeline = state.lifecycleFilter === "all"
    ? car.timeline
    : car.timeline.filter(t => t.cat === state.lifecycleFilter);

  return `
    <!-- Purchase & Acquisition Certificate Card -->
    <div class="ios-card" style="background:linear-gradient(145deg, rgba(192,132,252,0.16), rgba(56,189,248,0.06));">
      <div class="ios-card-header">
        <div class="ios-card-title">
          <span>🎖️ 提车与落户资产档案</span>
        </div>
        <button class="ios-card-link" onclick="openQuickLog('买车')">+ 记改装/车品</button>
      </div>

      <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:12px;" class="tabular-nums">
        <div style="background:var(--app-card-inner);padding:9px 10px;border-radius:16px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">落地总投入</div>
          <div style="font-size:15px;font-weight:800;margin-top:2px;">¥${(car.purchase.totalLanded/10000).toFixed(2)}万</div>
        </div>
        <div style="background:var(--app-card-inner);padding:9px 10px;border-radius:16px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">裸车开票价</div>
          <div style="font-size:15px;font-weight:800;margin-top:2px;">¥${(car.purchase.nakedPrice/10000).toFixed(2)}万</div>
        </div>
        <div style="background:var(--app-card-inner);padding:9px 10px;border-radius:16px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">当前估值</div>
          <div style="font-size:15px;font-weight:800;color:var(--accent-emerald);margin-top:2px;">¥${(car.purchase.estimatedResale/10000).toFixed(2)}万</div>
        </div>
      </div>

      <div style="font-size:11.5px;color:var(--app-text-secondary);display:flex;flex-direction:column;gap:5px;" class="tabular-nums">
        <div style="display:flex;justify-content:space-between;">
          <span>购置税 + 车管所上牌费</span>
          <strong style="color:var(--app-text);">${formatMoney(car.purchase.tax + car.purchase.regAndPlate)}</strong>
        </div>
        <div style="display:flex;justify-content:space-between;">
          <span>首年车险 + 精品改装 (车衣/太阳膜/车品)</span>
          <strong style="color:var(--app-text);">${formatMoney(car.purchase.firstInsurance + car.purchase.accessories)}</strong>
        </div>
        <div style="display:flex;justify-content:space-between;">
          <span>车架号 VIN / 购置方式</span>
          <strong style="color:var(--app-text);font-size:11px;">${car.purchase.loanStatus}</strong>
        </div>
      </div>
    </div>

    <!-- Total Cost of Ownership (TCO) Breakdown -->
    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">📊 拥车总成本结构 (TCO 透视)</div>
        <span style="font-size:11.5px;color:var(--app-text-secondary);font-weight:600;" class="tabular-nums">综合 ¥${((runningCosts + depreciation)/car.odometer).toFixed(2)}/km</span>
      </div>

      <div style="display:flex;height:10px;border-radius:99px;overflow:hidden;gap:2px;margin-bottom:12px;">
        <div style="width:38%;background:#fbbf24;" title="油费/电费"></div>
        <div style="width:34%;background:#34d399;" title="保险费用"></div>
        <div style="width:14%;background:#38bdf8;" title="保养维修"></div>
        <div style="width:14%;background:#c084fc;" title="停车高速美容"></div>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;font-size:12px;" class="tabular-nums">
        <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 11px;border-radius:14px;background:var(--app-card-inner);border:1px solid var(--app-border);">
          <span><span style="color:#fbbf24;">●</span> ${car.isEV ? "充换电费" : "燃油费"}</span>
          <strong>${formatMoney(car.totalFuelSpend)}</strong>
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 11px;border-radius:14px;background:var(--app-card-inner);border:1px solid var(--app-border);">
          <span><span style="color:#34d399;">●</span> 历年保险</span>
          <strong>${formatMoney(car.totalInsuranceSpend)}</strong>
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 11px;border-radius:14px;background:var(--app-card-inner);border:1px solid var(--app-border);">
          <span><span style="color:#38bdf8;">●</span> 保养维修</span>
          <strong>${formatMoney(car.totalMaintSpend)}</strong>
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 11px;border-radius:14px;background:var(--app-card-inner);border:1px solid var(--app-border);">
          <span><span style="color:#c084fc;">●</span> 停车/ETC/美容</span>
          <strong>${formatMoney(car.totalOtherSpend)}</strong>
        </div>
      </div>
    </div>

    <!-- Full Lifecycle Timeline -->
    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">🧭 从买车到上路 · 全生命周期时间轴</div>
      </div>

      <div class="segmented-control">
        <button class="seg-btn ${state.lifecycleFilter === 'all' ? 'active' : ''}" onclick="setLifecycleFilter('all')">全部</button>
        <button class="seg-btn ${state.lifecycleFilter === '买车' ? 'active' : ''}" onclick="setLifecycleFilter('买车')">买车</button>
        <button class="seg-btn ${state.lifecycleFilter === '上路' ? 'active' : ''}" onclick="setLifecycleFilter('上路')">上路</button>
        <button class="seg-btn ${state.lifecycleFilter === '保养' ? 'active' : ''}" onclick="setLifecycleFilter('保养')">维保</button>
        <button class="seg-btn ${state.lifecycleFilter === '保险' ? 'active' : ''}" onclick="setLifecycleFilter('保险')">保险</button>
      </div>

      <div class="timeline-list">
        ${filteredTimeline.map(item => renderTimelineNode(item)).join("")}
      </div>
    </div>
  `;
}

// ==========================================
// SCREEN 3: FUEL & ODOMETER LAB (油耗/能耗与里程实验室)
// ==========================================
function buildFuelScreen(car) {
  return `
    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">⛽ ${car.isEV ? "补能与百公里电耗曲线" : "满箱油耗与油价监控"}</div>
        <span class="status-chip chip-amber">${car.energyType}</span>
      </div>

      <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:14px;" class="tabular-nums">
        <div style="padding:10px;border-radius:18px;background:var(--accent-amber-soft);border:1px solid rgba(251,191,36,0.3);">
          <div style="font-size:10px;color:var(--app-text-secondary);">平均${car.isEV ? "电耗" : "油耗"}</div>
          <div style="font-size:17px;font-weight:800;color:var(--accent-amber);margin-top:2px;">${car.avgConsumption}</div>
          <div style="font-size:10px;color:var(--app-text-tertiary);">${car.consumptionUnit}</div>
        </div>
        <div style="padding:10px;border-radius:18px;background:var(--accent-emerald-soft);border:1px solid rgba(52,211,153,0.3);">
          <div style="font-size:10px;color:var(--app-text-secondary);">每公里成本</div>
          <div style="font-size:17px;font-weight:800;color:var(--accent-emerald);margin-top:2px;">¥${car.energyCostPerKm}</div>
          <div style="font-size:10px;color:var(--app-text-tertiary);">元 / 公里</div>
        </div>
        <div style="padding:10px;border-radius:18px;background:var(--accent-blue-soft);border:1px solid rgba(56,189,248,0.3);">
          <div style="font-size:10px;color:var(--app-text-secondary);">累计${car.isEV ? "电费" : "油费"}</div>
          <div style="font-size:17px;font-weight:800;color:var(--accent-blue);margin-top:2px;">${formatMoney(car.totalFuelSpend)}</div>
          <div style="font-size:10px;color:var(--app-text-tertiary);">共 ${car.fuelLogs.length * 8} 次记录</div>
        </div>
      </div>

      <!-- SVG Consumption Trend Chart -->
      <div style="background:rgba(0,0,0,0.2);border-radius:20px;padding:12px 10px 8px;border:1px solid var(--app-border);">
        <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--app-text-secondary);margin-bottom:6px;">
          <span>近 5 次加注实测波动 (${car.consumptionUnit})</span>
          <span style="color:var(--accent-emerald);font-weight:700;">● 黄金右脚区间</span>
        </div>
        <svg width="100%" height="96" viewBox="0 0 310 96" fill="none">
          <defs>
            <linearGradient id="fuelChartFill" x1="0" y1="10" x2="0" y2="90" gradientUnits="userSpaceOnUse">
              <stop offset="0%" stop-color="#ff5e2b" stop-opacity="0.42"/>
              <stop offset="100%" stop-color="#ff5e2b" stop-opacity="0.0"/>
            </linearGradient>
          </defs>
          <line x1="12" y1="46" x2="298" y2="46" stroke="rgba(52,211,153,0.45)" stroke-dasharray="4 4" stroke-width="1"/>
          <path d="M24 44 L92 56 L156 26 L224 54 L286 38 L286 84 L24 84 Z" fill="url(#fuelChartFill)"/>
          <path d="M24 44 L92 56 L156 26 L224 54 L286 38" stroke="#ff5e2b" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/>
          <circle cx="24" cy="44" r="4" fill="#171b24" stroke="#ff5e2b" stroke-width="2.5"/>
          <circle cx="92" cy="56" r="4" fill="#171b24" stroke="#ff5e2b" stroke-width="2.5"/>
          <circle cx="156" cy="26" r="4.5" fill="#34d399" stroke="#fff" stroke-width="2"/>
          <circle cx="224" cy="54" r="4" fill="#171b24" stroke="#ff5e2b" stroke-width="2.5"/>
          <circle cx="286" cy="38" r="4.5" fill="#ff5e2b" stroke="#fff" stroke-width="2"/>
          <text x="16" y="78" fill="#94a3b8" font-size="9.5">09-05</text>
          <text x="80" y="78" fill="#94a3b8" font-size="9.5">09-21</text>
          <text x="144" y="78" fill="#34d399" font-size="9.5" font-weight="700">10-07</text>
          <text x="212" y="78" fill="#94a3b8" font-size="9.5">10-22</text>
          <text x="270" y="78" fill="#f8fafc" font-size="9.5" font-weight="700">最新</text>
        </svg>
      </div>
    </div>

    <!-- Detailed Refueling Ledger -->
    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">🧾 每次${car.isEV ? "充换电" : "加油"}跳枪明细</div>
        <button class="ios-card-link" onclick="openQuickLog('加油')">+ 记油耗</button>
      </div>

      <div style="display:flex;flex-direction:column;gap:9px;">
        ${car.fuelLogs.map(log => `
          <div style="padding:11px 13px;border-radius:18px;background:var(--app-card-inner);border:1px solid var(--app-border);">
            <div style="display:flex;justify-content:space-between;align-items:center;">
              <div style="font-size:13px;font-weight:700;">${log.date} · ${log.station}</div>
              <span style="font-size:13.5px;font-weight:800;" class="tabular-nums">-¥${log.cost.toFixed(1)}</span>
            </div>
            <div style="display:flex;justify-content:space-between;margin-top:5px;font-size:11.5px;color:var(--app-text-secondary);" class="tabular-nums">
              <span>里程 ${log.odo.toLocaleString()} km (+${log.deltaKm}km)</span>
              <span style="color:var(--accent-amber);font-weight:700;">⚡ ${log.consumption} ${car.consumptionUnit}</span>
            </div>
            <div style="display:flex;justify-content:space-between;margin-top:4px;font-size:10.5px;color:var(--app-text-tertiary);" class="tabular-nums">
              <span>加注 ${log.volume} ${car.isEV ? "kWh" : "L"} × ¥${log.price}/${car.isEV ? "度" : "L"}</span>
              <span>${log.note}</span>
            </div>
          </div>
        `).join("")}
      </div>
    </div>
  `;
}

// ==========================================
// SCREEN 4: MAINTENANCE & REPAIR (维保健康度与工单档案)
// ==========================================
function buildMaintenanceScreen(car) {
  return `
    <div class="segmented-control">
      <button class="seg-btn active" onclick="switchTab('maintenance')">🔧 保养与故障维修</button>
      <button class="seg-btn" onclick="switchTab('insurance')">🛡️ 车险保单与上路合规</button>
    </div>

    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">🛠️ 关键易损件寿命监控 (里程 × 时间双维)</div>
        <button class="ios-card-link" onclick="openQuickLog('保养')">+ 保养重置</button>
      </div>

      <div>
        ${car.maintenanceParts.map(part => {
          const barColor = part.pct <= 25 ? "var(--accent-amber)" : "var(--accent-emerald)";
          return `
            <div class="maint-item" onclick="openQuickLog('保养')">
              <div class="maint-top">
                <span class="maint-name">
                  <span style="width:7px;height:7px;border-radius:50%;background:${barColor};box-shadow:0 0 6px ${barColor};"></span>
                  ${part.name}
                </span>
                <span class="maint-pct tabular-nums" style="color:${barColor};">剩余 ${part.pct}%</span>
              </div>
              <div style="font-size:11px;color:var(--app-text-tertiary);margin-top:2px;">规格: ${part.spec}</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:${part.pct}%;background:${barColor};"></div>
              </div>
              <div class="maint-sub tabular-nums">
                <span>已跑 ${part.usedKm.toLocaleString()} / ${part.limitKm.toLocaleString()} km</span>
                <span>上次: ${part.lastDate}</span>
              </div>
            </div>
          `;
        }).join("")}
      </div>
    </div>

    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">📋 历史保养与故障维修工单</div>
        <button class="ios-card-link" onclick="openQuickLog('维修')">+ 记维修</button>
      </div>

      <div style="display:flex;flex-direction:column;gap:10px;">
        ${car.serviceRecords.map(rec => `
          <div style="padding:12px;border-radius:18px;background:var(--app-card-inner);border:1px solid var(--app-border);">
            <div style="display:flex;justify-content:space-between;align-items:center;">
              <strong style="font-size:13px;">${rec.type}</strong>
              <strong style="font-size:13.5px;color:var(--accent-blue);" class="tabular-nums">¥${rec.cost.toLocaleString()}</strong>
            </div>
            <div style="font-size:11px;color:var(--app-text-secondary);margin-top:4px;" class="tabular-nums">
              📅 ${rec.date} · 📍 ${rec.shop} · 🛣️ ${rec.odo.toLocaleString()} km
            </div>
            <div class="timeline-badges" style="margin-top:8px;">
              ${rec.items.map(i => `<span class="micro-tag">${i}</span>`).join("")}
              <span class="micro-tag" style="color:var(--accent-blue);">📎 电子工单</span>
            </div>
          </div>
        `).join("")}
      </div>
    </div>
  `;
}

// ==========================================
// SCREEN 5: INSURANCE & COMPLIANCE (保险与合规证件夹)
// ==========================================
function buildInsuranceScreen(car) {
  const ins = car.insurance;
  return `
    <div class="segmented-control">
      <button class="seg-btn" onclick="switchTab('maintenance')">🔧 保养与故障维修</button>
      <button class="seg-btn active" onclick="switchTab('insurance')">🛡️ 车险保单与上路合规</button>
    </div>

    <div class="ios-card" style="background:linear-gradient(150deg, rgba(52,211,153,0.16), rgba(15,23,42,0.35));">
      <div class="ios-card-header">
        <div>
          <div style="font-size:15px;font-weight:800;">🛡️ ${ins.company}</div>
          <div style="font-size:11px;color:var(--app-text-secondary);margin-top:2px;font-family:var(--font-mono);">保单号: ${ins.policyNo}</div>
        </div>
        <button class="ios-card-link" onclick="openQuickLog('保险')">+ 续保/出险</button>
      </div>

      <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin:12px 0;" class="tabular-nums">
        <div style="background:var(--app-card-inner);padding:9px;border-radius:15px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">年度总保费</div>
          <div style="font-size:15px;font-weight:800;margin-top:2px;">¥${ins.totalPremium.toLocaleString()}</div>
        </div>
        <div style="background:var(--app-card-inner);padding:9px;border-radius:15px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">交强 + 商业</div>
          <div style="font-size:12px;font-weight:800;margin-top:4px;">¥${ins.compulsory}+${ins.commercial}</div>
        </div>
        <div style="background:var(--app-card-inner);padding:9px;border-radius:15px;border:1px solid var(--app-border);">
          <div style="font-size:10px;color:var(--app-text-secondary);">剩余保障期</div>
          <div style="font-size:14px;font-weight:800;color:var(--accent-emerald);margin-top:2px;">${ins.daysRemaining} 天</div>
        </div>
      </div>

      <div style="display:flex;flex-direction:column;gap:6px;margin-top:8px;">
        ${ins.coverages.map(cov => `
          <div style="display:flex;justify-content:space-between;align-items:center;font-size:11.5px;padding:6.5px 10px;border-radius:12px;background:var(--app-card-inner);border:1px solid var(--app-border);" class="tabular-nums">
            <span>${cov.name}</span>
            <span><strong style="color:var(--app-text-secondary);margin-right:8px;">保额 ${cov.amount}</strong> <strong>${cov.premium}</strong></span>
          </div>
        `).join("")}
      </div>

      <div style="display:flex;gap:8px;margin-top:12px;">
        <button class="studio-btn" style="flex:1;justify-content:center;font-size:11.5px;" onclick="showAppToast('已打开电子保单 PDF 原件')">📄 电子保单原件</button>
        <button class="studio-btn" style="flex:1;justify-content:center;font-size:11.5px;" onclick="showAppToast('出险试算：若出险1次，明年保费预计上浮 ¥1,420')">🧮 出险涨价试算</button>
      </div>
    </div>

    <div class="ios-card">
      <div class="ios-card-header">
        <div class="ios-card-title">🪪 上路合规 & 数字手套箱</div>
        <button class="ios-card-link" onclick="openQuickLog('上路')">+ 记停车/车务</button>
      </div>

      <div style="display:flex;flex-direction:column;gap:9px;font-size:12px;">
        <div style="padding:10px 12px;border-radius:16px;background:var(--app-card-inner);border:1px solid var(--app-border);display:flex;justify-content:space-between;align-items:center;">
          <div>
            <div style="font-weight:700;">🔍 年检与免检标志</div>
            <div style="font-size:11px;color:var(--app-text-secondary);margin-top:2px;">${ins.compliance.inspectionExpire}</div>
          </div>
          <span class="status-chip chip-emerald">正常</span>
        </div>

        <div style="padding:10px 12px;border-radius:16px;background:var(--app-card-inner);border:1px solid var(--app-border);display:flex;justify-content:space-between;align-items:center;">
          <div>
            <div style="font-weight:700;">🚦 违章与驾照记分监控</div>
            <div style="font-size:11px;color:var(--app-text-secondary);margin-top:2px;">${ins.compliance.violations}</div>
          </div>
          <span class="status-chip chip-emerald">0 违章</span>
        </div>

        <div style="padding:10px 12px;border-radius:16px;background:var(--app-card-inner);border:1px solid var(--app-border);display:flex;justify-content:space-between;align-items:center;">
          <div>
            <div style="font-weight:700;">🛣️ 高速 ETC 通行卡</div>
            <div style="font-size:11px;color:var(--app-text-secondary);margin-top:2px;">${ins.compliance.etcCard}</div>
          </div>
          <button class="ios-card-link" onclick="openQuickLog('上路')">记通行 ›</button>
        </div>

        <div style="padding:10px 12px;border-radius:16px;background:var(--app-card-inner);border:1px solid var(--app-border);display:flex;justify-content:space-between;align-items:center;">
          <div>
            <div style="font-weight:700;">🔢 车架号 VIN & 发动机号</div>
            <div style="font-size:11px;color:var(--app-text-secondary);margin-top:2px;font-family:var(--font-mono);">${car.vin}</div>
          </div>
          <button class="ios-card-link" onclick="showAppToast('已复制车架号 VIN 至剪贴板')">复制</button>
        </div>
      </div>
    </div>
  `;
}

// ==========================================
// BESPOKE CATEGORY FORMS FOR "+ 记一笔" SHEET
// ==========================================
function renderDynamicQuickLogForm() {
  const car = getCar();
  const cat = state.quickLogCat;
  const stage = document.getElementById("ql-dynamic-form-stage");
  const subtitle = document.getElementById("ql-sheet-subtitle");
  const submitBtn = document.getElementById("ql-submit-btn");
  if (!stage) return;

  if (cat === "加油") {
    if (subtitle) subtitle.textContent = car.isEV
      ? "记录家充谷电、超充或换电明细 · 自动计算百公里电耗"
      : "记录加油升数、油品标号与跳枪状态 · 自动折算满箱油耗";
    if (submitBtn) submitBtn.textContent = car.isEV ? "⚡ 确认记入补能账本 (更新电耗曲线)" : "⛽ 确认记入加油账本 (更新油耗曲线)";

    const fuelOptions = car.isEV
      ? ["7kW 家充桩(谷电)", "蔚来三代换电站", "品牌超充桩", "第三方快充"]
      : ["95# 汽油", "98# 汽油", "92# 汽油", "壳牌 V-Power"];
    if (!fuelOptions.includes(state.fuelSubType)) state.fuelSubType = fuelOptions[0];

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label">
          <span>${car.isEV ? "补能方式选择" : "油品标号与加注状态"}</span>
          <span style="color:var(--accent-emerald);cursor:pointer;" onclick="toggleFuelFullTank()">
            ${state.fuelFullTank ? "☑️ 已满箱跳枪 (精准算油耗)" : "⬜ 未加满 (仅累计油费)"}
          </span>
        </div>
        <div class="sub-option-pills">
          ${fuelOptions.map(opt => `
            <button type="button" class="sub-pill ${state.fuelSubType === opt ? 'selected' : ''}" onclick="setQuickSubOption('fuelSubType', '${opt}')">${opt}</button>
          `).join("")}
        </div>

        <div class="form-grid-3">
          <div class="form-group">
            <label>当前总里程 (km)</label>
            <input id="ql-odo" type="number" class="ios-input tabular-nums" value="${car.odometer + 510}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>实付金额 (¥)</label>
            <input id="ql-cost" type="number" step="0.1" class="ios-input tabular-nums" value="${car.isEV ? '48.5' : '345.0'}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>单价 (¥/${car.isEV ? '度' : '升'})</label>
            <input id="ql-price" type="number" step="0.01" class="ios-input tabular-nums" value="${car.isEV ? '0.78' : '7.96'}" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-group">
          <label>📍 ${car.isEV ? "充电站 / 换电站位置" : "加油站名称与优惠备注"}</label>
          <input id="ql-note" type="text" class="ios-input" value="${car.isEV ? '蔚来三代换电站 · 漕河泾开发区' : '壳牌 V-Power 世纪大道站 (周五立减)'}" />
        </div>
      </div>
    `;
  } else if (cat === "保养") {
    if (subtitle) subtitle.textContent = "勾选本次更换的保养项目 · 提交后自动将对应配件寿命重置为 100%";
    if (submitBtn) submitBtn.textContent = "🔧 确认归档保养工单 & 重置配件寿命";

    const shopTypes = ["品牌 4S 中心", "途虎养车工场店", "专修连锁门店", "DIY 自购保养"];
    const estSum = state.maintCheckedParts.reduce((acc, idx) => acc + (car.maintenanceParts[idx]?.estCost || 300), 0);

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label">
          <span>选择服务门店类型</span>
          <span>可多选下方更换配件</span>
        </div>
        <div class="sub-option-pills">
          ${shopTypes.map(t => `
            <button type="button" class="sub-pill ${state.maintShopType === t ? 'selected' : ''}" onclick="setQuickSubOption('maintShopType', '${t}')">${t}</button>
          `).join("")}
        </div>

        <div class="form-section-label">
          <span>☑️ 勾选本次保养更换项目 (勾选即重置寿命至 100%)</span>
          <span style="color:var(--accent-blue);">已选 ${state.maintCheckedParts.length} 项</span>
        </div>
        <div class="check-chip-grid">
          ${car.maintenanceParts.map((part, idx) => {
            const isChecked = state.maintCheckedParts.includes(idx);
            return `
              <button type="button" class="check-chip ${isChecked ? 'checked' : ''}" onclick="toggleMaintPartCheck(${idx})">
                <span class="check-box-indicator">${isChecked ? '✓' : ''}</span>
                <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${part.name}</span>
              </button>
            `;
          }).join("")}
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>保养时总里程 (km)</label>
            <input id="ql-odo" type="number" class="ios-input tabular-nums" value="${car.odometer}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>工时+材料总费用 (¥)</label>
            <input id="ql-cost" type="number" class="ios-input tabular-nums" value="${estSum || 1180}" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-group">
          <label>🏥 施工门店与机油/配件批次备注</label>
          <input id="ql-note" type="text" class="ios-input" value="${car.isEV ? '蔚来服务中心 · 年度三电健检' : '上海宝诚宝马 4S · 0W-20全合成保养'}" />
        </div>
      </div>
    `;
  } else if (cat === "维修") {
    if (subtitle) subtitle.textContent = "记录故障部位、维修方案、质保期限与理赔结算方式";
    if (submitBtn) submitBtn.textContent = "🛠️ 确认记入故障维修档案";

    const areas = ["🛞 轮胎/轮毂", "🔋 电瓶/电路", "🎨 钣金喷漆", "⚙️ 底盘悬挂", "🪟 玻璃/车灯"];
    const claims = ["💳 自费维修", "🛡️ 厂家质保索赔(¥0)", "📑 走自己车损险", "⚖️ 对方全责赔付"];

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label"><span>故障系统部位</span></div>
        <div class="sub-option-pills">
          ${areas.map(a => `
            <button type="button" class="sub-pill ${state.repairPartArea === a ? 'selected' : ''}" onclick="setQuickSubOption('repairPartArea', '${a}')">${a}</button>
          `).join("")}
        </div>

        <div class="form-section-label"><span>结算与保险理赔方式</span></div>
        <div class="sub-option-pills">
          ${claims.map(c => `
            <button type="button" class="sub-pill ${state.repairClaimType === c ? 'selected' : ''}" onclick="setQuickSubOption('repairClaimType', '${c}')">${c}</button>
          `).join("")}
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>送修时总里程 (km)</label>
            <input id="ql-odo" type="number" class="ios-input tabular-nums" value="${car.odometer}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>自付维修金额 (¥)</label>
            <input id="ql-cost" type="number" class="ios-input tabular-nums" value="${state.repairClaimType.includes('¥0') || state.repairClaimType.includes('对方') ? 0 : 260}" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>故障现象与处理方案</label>
            <input id="ql-note" type="text" class="ios-input" value="右后轮扎钉 · 蘑菇钉内补+动平衡" />
          </div>
          <div class="form-group">
            <label>配件质保期承诺</label>
            <input id="ql-warranty" type="text" class="ios-input" value="门店质保 1年 / 2万公里" />
          </div>
        </div>
      </div>
    `;
  } else if (cat === "保险") {
    if (subtitle) subtitle.textContent = "录入交强险、商业险保费明细与未出险折扣，自动激活 365 天倒计时";
    if (submitBtn) submitBtn.textContent = "🛡️ 确认归档电子保单 (刷新保障倒计时)";

    const companies = ["🛡️ 中国平安车险", "🌊 太平洋产险", "🏛️ 人保财险 PICC", "⚡ 官方合作智驾险"];
    const insItems = [
      "机动车损失险 (车损)",
      "第三者责任险 (300万)",
      "医保外医疗费用险",
      "司乘人员责任险",
      "外部电网/三电附加险",
      "无限次道路救援+代驾"
    ];

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label"><span>选择承保保险公司</span></div>
        <div class="sub-option-pills">
          ${companies.map(c => `
            <button type="button" class="sub-pill ${state.insCompany === c ? 'selected' : ''}" onclick="setQuickSubOption('insCompany', '${c}')">${c}</button>
          `).join("")}
        </div>

        <div class="form-section-label">
          <span>商业险投保组合勾选</span>
          <span style="color:var(--accent-emerald);">NCD 0.7 连续未出险优待</span>
        </div>
        <div class="check-chip-grid">
          ${insItems.map((item, idx) => {
            const isChecked = state.insCheckedItems.includes(idx);
            return `
              <button type="button" class="check-chip ${isChecked ? 'checked' : ''}" onclick="toggleInsItemCheck(${idx})">
                <span class="check-box-indicator">${isChecked ? '✓' : ''}</span>
                <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${item}</span>
              </button>
            `;
          }).join("")}
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>交强险+车船税 (¥)</label>
            <input id="ql-compulsory" type="number" class="ios-input tabular-nums" value="855" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>商业险合计 (¥)</label>
            <input id="ql-commercial" type="number" class="ios-input tabular-nums" value="5680" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-group">
          <label>🎁 保单生效日与赠送权益包备注</label>
          <input id="ql-note" type="text" class="ios-input" value="赠3次酒后代驾 + 2次免费洗车 + 免费年检代办" />
        </div>
      </div>
    `;
  } else if (cat === "上路") {
    if (subtitle) subtitle.textContent = "记录停车费、高速 ETC 通行、精洗美容、违章罚款或年检审车";
    if (submitBtn) submitBtn.textContent = "🛣️ 确认记入日常上路与车务账本";

    const roadTypes = ["🅿️ 停车费/月租", "🛣️ 高速 ETC 通行", "🧼 洗车/打蜡精洗", "🚦 违章罚款记分", "🔍 年检审车"];
    const defaultCosts = {
      "🅿️ 停车费/月租": 40,
      "🛣️ 高速 ETC 通行": 85,
      "🧼 洗车/打蜡精洗": 68,
      "🚦 违章罚款记分": 200,
      "🔍 年检审车": 260
    };
    const defaultNotes = {
      "🅿️ 停车费/月租": "上海国金中心 IFC 地下车库临停 4小时",
      "🛣️ 高速 ETC 通行": "沪昆高速 G60 枫泾收费站 ETC 95折通行",
      "🧼 洗车/打蜡精洗": "双手桶中性泡沫精洗 + 轮毂铁粉去除",
      "🚦 违章罚款记分": "实线变道 · 罚款 ¥200 / 记 1 分",
      "🔍 年检审车": "机动车检测站尾气与安全技术上线年检"
    };

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label"><span>日常上路与车务细分类型 (点击切换预设)</span></div>
        <div class="sub-option-pills">
          ${roadTypes.map(rt => `
            <button type="button" class="sub-pill ${state.roadExpenseType === rt ? 'selected' : ''}" onclick="setQuickSubOption('roadExpenseType', '${rt}')">${rt}</button>
          `).join("")}
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>发生金额 (¥)</label>
            <input id="ql-cost" type="number" class="ios-input tabular-nums" value="${defaultCosts[state.roadExpenseType] || 50}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>${state.roadExpenseType.includes("违章") ? "驾驶证记分 (分)" : "当前总里程 (km)"}</label>
            <input id="ql-odo" type="number" class="ios-input tabular-nums" value="${state.roadExpenseType.includes("违章") ? 0 : car.odometer}" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-group">
          <label>📍 地点 / 高速路段 / 详细事项</label>
          <input id="ql-note" type="text" class="ios-input" value="${defaultNotes[state.roadExpenseType] || ''}" />
        </div>
      </div>
    `;
  } else if (cat === "买车") {
    if (subtitle) subtitle.textContent = "记录隐形车衣、改色膜、轮毂卡钳改装、车载精品或购车落户税费";
    if (submitBtn) submitBtn.textContent = "✨ 确认记入车辆固定资产与改装档案";

    const modTypes = ["🛡️ 隐形车衣/改色膜", "🛞 轮毂/卡钳/避震", "📷 记录仪/脚垫车品", "🎖️ 购置税/上牌落户"];
    const modDefaults = {
      "🛡️ 隐形车衣/改色膜": { cost: 6800, note: "XPEL LUX Plus 8.5mil 隐形车衣 · 10年电子质保" },
      "🛞 轮毂/卡钳/避震": { cost: 9500, note: "BBS 19寸锻造轮毂 + Brembo 六活塞卡钳 (已备案)" },
      "📷 记录仪/脚垫车品": { cost: 1280, note: "盯盯拍 4K 隐藏式行车记录仪 + 3W 全TPE脚垫" },
      "🎖️ 购置税/上牌落户": { cost: 500, note: "车管所选号牌证费 + 固封螺丝安装" }
    };
    const preset = modDefaults[state.modSubType] || modDefaults["🛡️ 隐形车衣/改色膜"];

    stage.innerHTML = `
      <div class="dynamic-form-stage">
        <div class="form-section-label"><span>改装升级与购车项目归类</span></div>
        <div class="sub-option-pills">
          ${modTypes.map(mt => `
            <button type="button" class="sub-pill ${state.modSubType === mt ? 'selected' : ''}" onclick="setQuickSubOption('modSubType', '${mt}')">${mt}</button>
          `).join("")}
        </div>

        <div class="form-grid-2">
          <div class="form-group">
            <label>投入金额 (¥)</label>
            <input id="ql-cost" type="number" class="ios-input tabular-nums" value="${preset.cost}" oninput="recalcQuickLogPreview()" />
          </div>
          <div class="form-group">
            <label>安装/办理时里程 (km)</label>
            <input id="ql-odo" type="number" class="ios-input tabular-nums" value="${car.odometer}" oninput="recalcQuickLogPreview()" />
          </div>
        </div>

        <div class="form-group">
          <label>✨ 品牌型号、施工门店与车管所备案状态</label>
          <input id="ql-note" type="text" class="ios-input" value="${preset.note}" />
        </div>
      </div>
    `;
  }

  recalcQuickLogPreview();
}

function setQuickSubOption(key, val) {
  state[key] = val;
  renderDynamicQuickLogForm();
}

function toggleFuelFullTank() {
  state.fuelFullTank = !state.fuelFullTank;
  renderDynamicQuickLogForm();
}

function toggleMaintPartCheck(idx) {
  const pos = state.maintCheckedParts.indexOf(idx);
  if (pos >= 0) state.maintCheckedParts.splice(pos, 1);
  else state.maintCheckedParts.push(idx);
  renderDynamicQuickLogForm();
}

function toggleInsItemCheck(idx) {
  const pos = state.insCheckedItems.indexOf(idx);
  if (pos >= 0) state.insCheckedItems.splice(pos, 1);
  else state.insCheckedItems.push(idx);
  renderDynamicQuickLogForm();
}

function recalcQuickLogPreview() {
  const car = getCar();
  const cat = state.quickLogCat;
  const previewEl = document.getElementById("ql-calc-preview");
  if (!previewEl) return;

  if (cat === "加油") {
    const odo = parseFloat(document.getElementById("ql-odo")?.value || car.odometer + 500);
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 340);
    const price = parseFloat(document.getElementById("ql-price")?.value || 7.96);
    const deltaKm = Math.max(50, odo - car.odometer);
    const liters = price > 0 ? (cost / price) : 42;
    const consumption = ((liters / deltaKm) * 100).toFixed(2);
    const perKm = (cost / deltaKm).toFixed(2);

    previewEl.innerHTML = `
      <span>⚡ 折算加注 <strong>${liters.toFixed(1)} ${car.isEV ? "kWh" : "L"}</strong> · 阶段 <strong>+${deltaKm} km</strong></span>
      <strong style="color:var(--accent-emerald);">实测 ${consumption} ${car.consumptionUnit} (¥${perKm}/km)</strong>
    `;
  } else if (cat === "保养") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 1180);
    const count = state.maintCheckedParts.length;
    previewEl.innerHTML = `
      <span>🔄 将重置 <strong>${count} 项</strong>配件寿命至 <strong>100%</strong></span>
      <strong style="color:var(--accent-blue);">下次保养提醒：${(car.odometer + 10000).toLocaleString()} km · 合计 ¥${cost}</strong>
    `;
  } else if (cat === "维修") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 260);
    const impact = state.repairClaimType.includes("车损险")
      ? "⚠️ 走车损险：预计次年保费上浮约 ¥1,420"
      : "✅ 不动用商业险：次年保费维持 NCD 最优折扣";
    previewEl.innerHTML = `
      <span>${state.repairPartArea} · 自付 <strong>¥${cost}</strong></span>
      <strong style="color:var(--accent-emerald);">${impact}</strong>
    `;
  } else if (cat === "保险") {
    const comp = parseFloat(document.getElementById("ql-compulsory")?.value || 855);
    const comm = parseFloat(document.getElementById("ql-commercial")?.value || 5680);
    const total = comp + comm;
    const daily = (total / 365).toFixed(1);
    previewEl.innerHTML = `
      <span>🛡️ 年度总保费 <strong>¥${total.toLocaleString()}</strong> (含 ${state.insCheckedItems.length} 项险种)</span>
      <strong style="color:var(--accent-emerald);">折合日均 ¥${daily}/天 · 保障期 365 天</strong>
    `;
  } else if (cat === "上路") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 50);
    previewEl.innerHTML = `
      <span>📊 归入「${state.roadExpenseType}」车务分项</span>
      <strong style="color:var(--accent-purple);">累计停车/ETC/车务更新为 ¥${(car.totalOtherSpend + cost).toLocaleString()}</strong>
    `;
  } else if (cat === "买车") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 6800);
    const newTotal = ((car.purchase.totalLanded + cost) / 10000).toFixed(2);
    previewEl.innerHTML = `
      <span>✨ 归入「${state.modSubType}」车辆资产档案</span>
      <strong style="color:var(--accent-purple);">落地与改装总投入将更新为 ¥${newTotal}万</strong>
    `;
  }
}

function submitQuickLog() {
  const car = getCar();
  const cat = state.quickLogCat;
  const note = document.getElementById("ql-note")?.value || "新增车务记录";

  if (cat === "加油") {
    const odo = parseInt(document.getElementById("ql-odo")?.value || (car.odometer + 510), 10);
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 345);
    const price = parseFloat(document.getElementById("ql-price")?.value || 7.96);
    const deltaKm = Math.max(10, odo - car.odometer);
    const volume = +(cost / price).toFixed(1);
    const cons = +((volume / deltaKm) * 100).toFixed(2);

    car.odometer = odo;
    car.totalFuelSpend += Math.round(cost);
    car.avgConsumption = +((car.avgConsumption * 0.8 + cons * 0.2)).toFixed(2);
    car.fuelLogs.unshift({
      date: "11-10",
      odo: odo,
      deltaKm: deltaKm,
      volume: volume,
      price: price,
      cost: cost,
      consumption: cons,
      station: note,
      full: state.fuelFullTank,
      note: `${state.fuelSubType} · ${state.fuelFullTank ? "满箱跳枪" : "阶段加注"}`
    });
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "加油",
      color: "amber",
      title: `${state.fuelSubType} · ${note}`,
      cost: `-¥${cost.toFixed(1)}`,
      odo: `${odo.toLocaleString()} km`,
      tags: [`+${deltaKm} km`, `${volume} ${car.isEV ? 'kWh' : 'L'}`, `实测 ${cons}${car.consumptionUnit}`]
    });
    showAppToast(`✅ 已记入「${state.fuelSubType}」并刷新百公里能耗曲线！`);

  } else if (cat === "保养") {
    const odo = parseInt(document.getElementById("ql-odo")?.value || car.odometer, 10);
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 1180);
    const checkedNames = [];
    state.maintCheckedParts.forEach(idx => {
      if (car.maintenanceParts[idx]) {
        car.maintenanceParts[idx].usedKm = 0;
        car.maintenanceParts[idx].pct = 100;
        car.maintenanceParts[idx].lastDate = `2026-11-10 @ ${odo.toLocaleString()}km`;
        checkedNames.push(car.maintenanceParts[idx].name);
      }
    });
    car.odometer = Math.max(car.odometer, odo);
    car.totalMaintSpend += Math.round(cost);
    car.healthScore = 99;
    car.serviceRecords.unshift({
      date: "2026-11-10",
      type: `定期保养 (${state.maintShopType})`,
      shop: note,
      odo: odo,
      cost: cost,
      items: checkedNames.length ? checkedNames : ["常规检查保养"]
    });
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "保养",
      color: "blue",
      title: `定期保养 · ${note}`,
      cost: `-¥${cost.toFixed(1)}`,
      odo: `${odo.toLocaleString()} km`,
      tags: [state.maintShopType, ...checkedNames.slice(0, 2), "寿命已重置100%"]
    });
    showAppToast(`🔧 已完成保养登记，${checkedNames.length} 项配件寿命已重置为 100%！`);

  } else if (cat === "维修") {
    const odo = parseInt(document.getElementById("ql-odo")?.value || car.odometer, 10);
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 260);
    const warranty = document.getElementById("ql-warranty")?.value || "门店质保1年";
    car.totalMaintSpend += Math.round(cost);
    car.serviceRecords.unshift({
      date: "2026-11-10",
      type: `${state.repairPartArea} · ${note}`,
      shop: state.repairClaimType,
      odo: odo,
      cost: cost,
      items: [state.repairPartArea, state.repairClaimType, warranty]
    });
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "维修",
      color: "rose",
      title: `${state.repairPartArea} · ${note}`,
      cost: `-¥${cost.toFixed(1)}`,
      odo: `${odo.toLocaleString()} km`,
      tags: [state.repairClaimType, warranty]
    });
    showAppToast(`🛠️ 已记入「${state.repairPartArea}」故障维修档案！`);

  } else if (cat === "保险") {
    const comp = parseFloat(document.getElementById("ql-compulsory")?.value || 855);
    const comm = parseFloat(document.getElementById("ql-commercial")?.value || 5680);
    const total = comp + comm;
    car.insurance.company = state.insCompany.replace(/^[^\s]+\s/, "") + " · 尊享保障";
    car.insurance.compulsory = comp;
    car.insurance.commercial = comm;
    car.insurance.totalPremium = total;
    car.insurance.daysRemaining = 365;
    car.totalInsuranceSpend += Math.round(total);
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "保险",
      color: "emerald",
      title: `年度车险续保 · ${state.insCompany}`,
      cost: `-¥${total.toLocaleString()}`,
      odo: `${car.odometer.toLocaleString()} km`,
      tags: [`交强 ¥${comp}`, `商业 ¥${comm}`, note]
    });
    showAppToast(`🛡️ 已更新年度车险保单，365 天保障倒计时已激活！`);

  } else if (cat === "上路") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 50);
    car.totalOtherSpend += Math.round(cost);
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "上路",
      color: "purple",
      title: `${state.roadExpenseType} · ${note}`,
      cost: `-¥${cost.toFixed(1)}`,
      odo: `${car.odometer.toLocaleString()} km`,
      tags: [state.roadExpenseType, "日常车务"]
    });
    showAppToast(`🛣️ 已记入「${state.roadExpenseType}」日常车务支出！`);

  } else if (cat === "买车") {
    const cost = parseFloat(document.getElementById("ql-cost")?.value || 6800);
    car.purchase.accessories += Math.round(cost);
    car.purchase.totalLanded += Math.round(cost);
    car.timeline.unshift({
      date: "2026-11-10",
      cat: "买车",
      color: "purple",
      title: `${state.modSubType} · ${note}`,
      cost: `-¥${cost.toLocaleString()}`,
      odo: `${car.odometer.toLocaleString()} km`,
      tags: [state.modSubType, "计入车辆资产"]
    });
    showAppToast(`✨ 已记入「${state.modSubType}」并更新车辆总资产！`);
  }

  closeQuickLog();
  renderInteractivePhone();
}

// ==========================================
// RENDER CONTROLLER FOR INTERACTIVE PHONE & GALLERY
// ==========================================
function renderInteractivePhone() {
  const car = getCar();

  const plateEl = document.getElementById("top-plate-badge");
  const nameEl = document.getElementById("top-vehicle-name");
  if (plateEl && nameEl) {
    plateEl.textContent = car.plate;
    plateEl.className = "vehicle-plate-mini" + (car.isEV ? " ev" : "");
    nameEl.textContent = car.name;
  }

  const viewport = document.getElementById("interactive-viewport");
  if (viewport) {
    if (state.currentTab === "cockpit") viewport.innerHTML = buildCockpitScreen(car);
    else if (state.currentTab === "lifecycle") viewport.innerHTML = buildLifecycleScreen(car);
    else if (state.currentTab === "fuel") viewport.innerHTML = buildFuelScreen(car);
    else if (state.currentTab === "maintenance") viewport.innerHTML = buildMaintenanceScreen(car);
    else if (state.currentTab === "insurance") viewport.innerHTML = buildInsuranceScreen(car);
  }

  document.querySelectorAll(".tab-btn").forEach(btn => {
    const isMaintOrIns = btn.dataset.tab === "maintenance" && (state.currentTab === "maintenance" || state.currentTab === "insurance");
    btn.classList.toggle("active", btn.dataset.tab === state.currentTab || isMaintOrIns);
  });

  document.querySelectorAll(".screen-nav-item").forEach(item => {
    item.classList.toggle("active", item.dataset.screen === state.currentTab);
  });

  document.querySelectorAll(".vehicle-switch-btn").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.vid === state.currentVehicleId);
  });

  renderGalleryArtboards(car);
}

function renderGalleryArtboards(car) {
  const screens = [
    { id: "gal-cockpit", html: buildCockpitScreen(car) },
    { id: "gal-lifecycle", html: buildLifecycleScreen(car) },
    { id: "gal-fuel", html: buildFuelScreen(car) },
    { id: "gal-maintenance", html: buildMaintenanceScreen(car) },
    { id: "gal-insurance", html: buildInsuranceScreen(car) }
  ];
  screens.forEach(s => {
    const el = document.getElementById(s.id);
    if (el) el.innerHTML = s.html;
  });
}

// ==========================================
// INTERACTIVE NAVIGATION ACTIONS
// ==========================================
function switchTab(tabName) {
  state.currentTab = tabName;
  state.quickLogOpen = false;
  updateQuickLogSheet();
  renderInteractivePhone();
  const vp = document.getElementById("interactive-viewport-wrapper");
  if (vp) vp.scrollTop = 0;
}

function switchVehicle(vid) {
  state.currentVehicleId = vid;
  state.maintCheckedParts = [0, 1];
  renderInteractivePhone();
  if (state.quickLogOpen) renderDynamicQuickLogForm();
  const car = getCar();
  showAppToast(`已切换至：${car.fullName}`);
}

function setLifecycleFilter(filter) {
  state.lifecycleFilter = filter;
  renderInteractivePhone();
}

function toggleAppTheme(theme) {
  state.theme = theme;
  document.documentElement.setAttribute("data-theme", theme);
  document.querySelectorAll(".theme-pill").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.theme === theme);
  });
}

function setStudioMode(mode) {
  state.studioMode = mode;
  document.getElementById("interactive-stage").classList.toggle("hidden", mode !== "interactive");
  document.getElementById("gallery-stage").classList.toggle("active", mode === "gallery");
  document.querySelectorAll(".mode-pill").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.mode === mode);
  });
}

function openQuickLog(defaultCat) {
  if (defaultCat) state.quickLogCat = defaultCat;
  state.quickLogOpen = true;
  updateQuickLogSheet();
}

function closeQuickLog() {
  state.quickLogOpen = false;
  updateQuickLogSheet();
}

function selectQuickLogCat(cat) {
  state.quickLogCat = cat;
  updateQuickLogSheet();
}

function updateQuickLogSheet() {
  const backdrop = document.getElementById("quick-log-backdrop");
  if (!backdrop) return;
  backdrop.classList.toggle("open", state.quickLogOpen);

  document.querySelectorAll(".cat-pill").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.cat === state.quickLogCat);
  });

  renderDynamicQuickLogForm();
}

let toastTimer = null;
function showAppToast(msg) {
  const toast = document.getElementById("app-toast");
  if (!toast) return;
  toast.textContent = msg;
  toast.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.classList.remove("show");
  }, 2600);
}

window.addEventListener("DOMContentLoaded", () => {
  renderInteractivePhone();
  updateQuickLogSheet();
});
