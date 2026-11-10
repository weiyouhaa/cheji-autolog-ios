import Foundation
import SwiftUI

enum QuickLogCategory: String, CaseIterable, Identifiable, Codable {
    case fuel = "加油"
    case maintenance = "保养"
    case repair = "维修"
    case insurance = "保险"
    case onRoad = "上路"
    case purchaseMod = "买车"

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .fuel: return "⛽ 加油/补能"
        case .maintenance: return "🔧 定期保养"
        case .repair: return "🛠️ 故障维修"
        case .insurance: return "🛡️ 续保出险"
        case .onRoad: return "🛣️ 停车/车务"
        case .purchaseMod: return "✨ 改装/买车"
        }
    }
}

struct AutoLoanPlan: Codable, Equatable {
    var isFinanced: Bool
    var loanPrincipal: Double
    var annualRatePct: Double
    var totalMonths: Int
    var paidMonths: Int
    var monthlyPayment: Double
    var bankName: String

    var remainingMonths: Int {
        max(0, totalMonths - paidMonths)
    }

    var totalRepayment: Double {
        monthlyPayment * Double(totalMonths)
    }

    var totalInterest: Double {
        max(0, totalRepayment - loanPrincipal)
    }

    var remainingBalance: Double {
        monthlyPayment * Double(remainingMonths)
    }

    var estimatedInterestSavedOnEarlyPayoff: Double {
        guard remainingMonths > 0, totalMonths > 0 else { return 0 }
        let ratio = Double(remainingMonths) / Double(totalMonths)
        return (totalInterest * ratio * ratio * 0.85).rounded()
    }
}

struct PDICheckItem: Identifiable, Codable, Equatable {
    var id: String
    var category: String
    var title: String
    var detail: String
    var passed: Bool
}

struct PurchaseInfo: Codable, Equatable {
    var nakedPrice: Double
    var tax: Double
    var firstInsurance: Double
    var regAndPlate: Double
    var accessories: Double
    var totalLanded: Double
    var estimatedResale: Double
    var dealer: String
    var loanStatus: String
    var loanPlan: AutoLoanPlan = AutoLoanPlan(
        isFinanced: true,
        loanPrincipal: 180000,
        annualRatePct: 2.8,
        totalMonths: 36,
        paidMonths: 19,
        monthlyPayment: 5420,
        bankName: "宝马金融 / 招商银行车贷"
    )
    var pdiItems: [PDICheckItem] = SampleVehicles.defaultPDIItems
}

struct FuelLog: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: String
    var odo: Int
    var deltaKm: Int
    var volume: Double
    var price: Double
    var cost: Double
    var consumption: Double
    var station: String
    var full: Bool
    var note: String
}

struct DrivingTrip: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: String
    var title: String
    var scenario: String // 🏙️ 市区通勤 | 🛣️ 高速巡航 | ⛰️ 跑山露营
    var distanceKm: Int
    var avgSpeedKmh: Int
    var consumption: Double
}

struct MaintenancePart: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var spec: String
    var usedKm: Int
    var limitKm: Int
    var usedDays: Int
    var limitDays: Int
    var pct: Int
    var estCost: Double
    var lastDate: String
}

struct TireWheelStatus: Identifiable, Codable, Equatable {
    var id: String // FL | FR | RL | RR
    var positionName: String
    var pressureBar: Double
    var tempC: Int
    var treadMm: Double
    var brandSpec: String
    var patchCount: Int
}

struct ServiceRecord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: String
    var type: String
    var shop: String
    var odo: Int
    var cost: Double
    var items: [String]
}

struct CoverageItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var amount: String
    var premium: String
}

struct ComplianceInfo: Codable, Equatable {
    var inspectionExpire: String
    var violations: String
    var etcCard: String
}

struct InsuranceInfo: Codable, Equatable {
    var company: String
    var policyNo: String
    var expireDate: String
    var daysRemaining: Int
    var ncdFactor: String
    var totalPremium: Double
    var compulsory: Double
    var commercial: Double
    var coverages: [CoverageItem]
    var compliance: ComplianceInfo
}

struct TimelineEvent: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: String
    var cat: String
    var color: String // amber | blue | emerald | rose | purple
    var title: String
    var cost: String
    var odo: String
    var tags: [String]
}

struct Vehicle: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var fullName: String
    var plate: String
    var isEV: Bool
    var energyType: String
    var vin: String
    var engineNo: String
    var colorName: String
    var purchaseDate: String
    var daysOwned: Int
    var odometer: Int
    var dailyKm: Double
    var avgConsumption: Double
    var consumptionUnit: String
    var energyCostPerKm: Double
    var totalFuelSpend: Double
    var totalMaintSpend: Double
    var totalInsuranceSpend: Double
    var totalOtherSpend: Double
    var purchase: PurchaseInfo
    var healthScore: Int
    var nextAlert: String
    var fuelLogs: [FuelLog]
    var trips: [DrivingTrip] = SampleVehicles.defaultTrips
    var maintenanceParts: [MaintenancePart]
    var tires: [TireWheelStatus] = SampleVehicles.defaultTires
    var serviceRecords: [ServiceRecord]
    var insurance: InsuranceInfo
    var timeline: [TimelineEvent]

    var totalRunningCosts: Double {
        totalFuelSpend + totalMaintSpend + totalInsuranceSpend + totalOtherSpend
    }

    var depreciation: Double {
        max(0, purchase.totalLanded - purchase.estimatedResale)
    }

    var dailyHoldingCost: Double {
        let totalCostAll = purchase.totalLanded + totalFuelSpend + totalMaintSpend + totalInsuranceSpend - purchase.firstInsurance + totalOtherSpend
        let netHoldingCost = max(0, totalCostAll - purchase.estimatedResale)
        return netHoldingCost / Double(max(1, daysOwned))
    }

    var comprehensiveCostPerKm: Double {
        (totalRunningCosts + depreciation) / Double(max(1, odometer))
    }

    var fiveYearResaleProjections: [ResaleYearProjection] {
        let base = purchase.nakedPrice
        let factors: [Double] = isEV ? [0.78, 0.65, 0.54, 0.45, 0.38] : [0.84, 0.74, 0.64, 0.56, 0.48]
        let advices = [
            "准新车折旧最快期，建议继续持有摊薄购置成本",
            "车况黄金期，原厂质保内省心持有",
            "⭐ 黄金换车窗口期：折旧斜率趋缓且未进大修期",
            "适合追求极致性价比继续深耕，注意底盘橡胶件老化",
            "残值进入平台期，每多开一年边际折旧成本极低"
        ]
        var result: [ResaleYearProjection] = []
        var prev = purchase.totalLanded
        for i in 0..<5 {
            let val = (base * factors[i]).rounded()
            let drop = max(0, prev - val)
            result.append(
                ResaleYearProjection(
                    year: i + 1,
                    retentionPct: Int((factors[i] * 100).rounded()),
                    estimatedValue: val,
                    annualDrop: drop,
                    advice: advices[i]
                )
            )
            prev = val
        }
        return result
    }
}

struct ResaleYearProjection: Identifiable, Equatable {
    var id: Int { year }
    var year: Int
    var retentionPct: Int
    var estimatedValue: Double
    var annualDrop: Double
    var advice: String
}

enum SampleVehicles {
    static let defaultPDIItems: [PDICheckItem] = [
        PDICheckItem(id: "pdi_1", category: "外观与漆面", title: "全车漆面无划痕/色差 (流光反射检查)", detail: "原厂漆膜厚度 110~135μm 均匀一致", passed: true),
        PDICheckItem(id: "pdi_2", category: "外观与漆面", title: "全车玻璃与轮胎生产日期早于铭牌出厂日", detail: "防范运输途中更换配件", passed: true),
        PDICheckItem(id: "pdi_3", category: "铭牌与机械", title: "B柱车辆铭牌出厂日期 ≤ 3个月 (非库存车)", detail: "核对车架号 VIN 与发动机号", passed: true),
        PDICheckItem(id: "pdi_4", category: "铭牌与机械", title: "提车初始表显里程 ≤ 50 km", detail: "提车实测仅 12 km，轮胎胎毛完整", passed: true),
        PDICheckItem(id: "pdi_5", category: "内饰与电器", title: "座椅真皮无褶皱污渍 · 车机大屏与音响正常", detail: "CarPlay、360环影、空调制冷正常", passed: true),
        PDICheckItem(id: "pdi_6", category: "随车凭证", title: "购车发票四联 + 车辆合格证 + 一致性证书", detail: "两把原厂钥匙 + 随车三角牌与反光背心齐全", passed: true)
    ]

    static let defaultTrips: [DrivingTrip] = [
        DrivingTrip(date: "11-09", title: "沪杭高速 G60 巡航往返", scenario: "🛣️ 高速巡航", distanceKm: 186, avgSpeedKmh: 98, consumption: 6.4),
        DrivingTrip(date: "11-07", title: "陆家嘴—张江早晚高峰通勤", scenario: "🏙️ 市区通勤", distanceKm: 34, avgSpeedKmh: 26, consumption: 9.2),
        DrivingTrip(date: "10-26", title: "莫干山竹海盘山公路自驾", scenario: "⛰️ 跑山露营", distanceKm: 245, avgSpeedKmh: 62, consumption: 7.8)
    ]

    static let defaultTires: [TireWheelStatus] = [
        TireWheelStatus(id: "FL", positionName: "左前轮 (FL)", pressureBar: 2.45, tempC: 28, treadMm: 5.8, brandSpec: "米其林 PS4 225/45 R18", patchCount: 0),
        TireWheelStatus(id: "FR", positionName: "右前轮 (FR)", pressureBar: 2.50, tempC: 29, treadMm: 5.7, brandSpec: "米其林 PS4 225/45 R18", patchCount: 0),
        TireWheelStatus(id: "RL", positionName: "左后轮 (RL)", pressureBar: 2.60, tempC: 30, treadMm: 5.4, brandSpec: "米其林 PS4 245/40 R18", patchCount: 0),
        TireWheelStatus(id: "RR", positionName: "右后轮 (RR)", pressureBar: 2.32, tempC: 31, treadMm: 5.3, brandSpec: "米其林 PS4 245/40 R18", patchCount: 1)
    ]

    static let bmw330 = Vehicle(
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
        purchase: PurchaseInfo(
            nakedPrice: 318000,
            tax: 28142,
            firstInsurance: 8650,
            regAndPlate: 500,
            accessories: 9300,
            totalLanded: 364592,
            estimatedResale: 266000,
            dealer: "上海宝诚宝马 4S 中心",
            loanStatus: "已结清 (全款购置)"
        ),
        healthScore: 94,
        nextAlert: "四轮动平衡与换位 · 剩余 840 km",
        fuelLogs: [
            FuelLog(date: "11-06", odo: 24860, deltaKm: 562, volume: 43.8, price: 7.96, cost: 348.6, consumption: 7.79, station: "壳牌 V-Power 世纪大道站", full: true, note: "95# 满箱跳枪 · 高架顺畅"),
            FuelLog(date: "10-22", odo: 24298, deltaKm: 518, volume: 42.1, price: 7.96, cost: 335.1, consumption: 8.13, station: "中石化 延安西路站", full: true, note: "95# 满箱跳枪 · 市区通勤"),
            FuelLog(date: "10-07", odo: 23780, deltaKm: 590, volume: 44.5, price: 7.85, cost: 349.3, consumption: 7.54, station: "中石油 嘉松中路站", full: true, note: "95# 满箱跳枪 · 莫干山自驾"),
            FuelLog(date: "09-21", odo: 23190, deltaKm: 504, volume: 41.2, price: 7.85, cost: 323.4, consumption: 8.17, station: "壳牌 浦东锦绣路站", full: true, note: "95# 满箱跳枪 · 全程空调"),
            FuelLog(date: "09-05", odo: 22686, deltaKm: 535, volume: 42.0, price: 8.02, cost: 336.8, consumption: 7.85, station: "中石化 龙东大道站", full: true, note: "95# 满箱跳枪 · 常规通勤")
        ],
        maintenanceParts: [
            MaintenancePart(name: "四轮换位 & 动平衡", spec: "米其林 PS4 防爆胎", usedKm: 9160, limitKm: 10000, usedDays: 260, limitDays: 365, pct: 16, estCost: 180, lastDate: "2026-02-22 @ 15,700km"),
            MaintenancePart(name: "全合成机油 + 机滤", spec: "BMW 原厂 0W-20 LL-17FE+", usedKm: 4860, limitKm: 10000, usedDays: 142, limitDays: 365, pct: 52, estCost: 1180, lastDate: "2026-06-20 @ 20,000km"),
            MaintenancePart(name: "空调活性碳滤芯", spec: "曼牌 CUK 23014 抗菌型", usedKm: 4860, limitKm: 15000, usedDays: 142, limitDays: 365, pct: 68, estCost: 360, lastDate: "2026-06-20 @ 20,000km"),
            MaintenancePart(name: "NGK 铱铂金火花塞 (4支)", spec: "B48 专用 SILZKGR8B8S", usedKm: 4860, limitKm: 40000, usedDays: 142, limitDays: 1095, pct: 88, estCost: 960, lastDate: "2026-06-20 @ 20,000km"),
            MaintenancePart(name: "DOT4 低粘度制动液", spec: "博世 ENV6 刹车油", usedKm: 24860, limitKm: 40000, usedDays: 602, limitDays: 730, pct: 24, estCost: 420, lastDate: "出厂初装 (建议满2年更换)")
        ],
        serviceRecords: [
            ServiceRecord(date: "2026-06-20", type: "二保 · 2万公里大保养", shop: "上海宝诚宝马 4S", odo: 20000, cost: 2680, items: ["0W-20机油机滤", "火花塞×4", "空调滤芯", "全车电脑诊断"]),
            ServiceRecord(date: "2025-11-12", type: "右后胎扎钉蘑菇钉补胎", shop: "途虎养车工场店 (联洋)", odo: 14200, cost: 120, items: ["米其林内补蘑菇钉", "右后轮动平衡"]),
            ServiceRecord(date: "2025-01-18", type: "首保 · 1万公里常规保养", shop: "上海宝诚宝马 4S", odo: 10120, cost: 1180, items: ["0W-20全合成机油", "原厂机油滤清器", "底盘螺栓复紧"])
        ],
        insurance: InsuranceInfo(
            company: "中国平安产险 · 尊享车险",
            policyNo: "PAIC-2026-310115-88291",
            expireDate: "2027-03-17",
            daysRemaining: 128,
            ncdFactor: "0.70 (连续2年未出险)",
            totalPremium: 6800,
            compulsory: 855,
            commercial: 5945,
            coverages: [
                CoverageItem(name: "机动车损失险 (车损)", amount: "¥278,400", premium: "¥3,820"),
                CoverageItem(name: "第三者责任险", amount: "¥3,000,000", premium: "¥1,680"),
                CoverageItem(name: "医保外医疗费用责任险", amount: "¥100,000", premium: "¥165"),
                CoverageItem(name: "车上人员责任险 (司/乘)", amount: "¥100,000/座", premium: "¥280"),
                CoverageItem(name: "道路救援服务", amount: "全年无限次 100km", premium: "赠送")
            ],
            compliance: ComplianceInfo(
                inspectionExpire: "2028-03-31 (6年免检·第4年申领电子标)",
                violations: "0 条未处理 · 驾驶证 12 分满分",
                etcCard: "沪通卡 ETC · 本月通行 ¥185.00"
            )
        ),
        timeline: [
            TimelineEvent(date: "2026-11-06", cat: "加油", color: "amber", title: "壳牌 V-Power 95# 满箱加注", cost: "-¥348.6", odo: "24,860 km", tags: ["43.80 L", "实测油耗 7.79L/百公里", "单价 ¥7.96"]),
            TimelineEvent(date: "2026-06-20", cat: "保养", color: "blue", title: "20,000 km 4S店定期大保养", cost: "-¥2,680.0", odo: "20,000 km", tags: ["机油机滤", "火花塞×4", "空调滤", "发票已存"]),
            TimelineEvent(date: "2026-03-15", cat: "保险", color: "emerald", title: "第3年车险续保 (平安车险 NCD 0.7)", cost: "-¥6,800.0", odo: "16,800 km", tags: ["交强险 ¥855", "300万三者+车损 ¥5,945", "赠2次代驾"]),
            TimelineEvent(date: "2025-11-12", cat: "维修", color: "rose", title: "右后轮扎钉 · 蘑菇钉内补+动平衡", cost: "-¥120.0", odo: "14,200 km", tags: ["途虎工场店", "胎压恢复 2.5 Bar"]),
            TimelineEvent(date: "2024-03-22", cat: "上路", color: "purple", title: "车管所选号上牌 & 贴XPEL隐形车衣", cost: "-¥9,800.0", odo: "128 km", tags: ["沪A·889M3", "行驶证大绿本归档", "ETC激活"]),
            TimelineEvent(date: "2024-03-18", cat: "买车", color: "purple", title: "提车交付 · 2024款 BMW 330Li 曜夜", cost: "-¥354,792", odo: "12 km", tags: ["裸车 ¥31.8万", "购置税 ¥28,142", "首保险 ¥8,650"])
        ]
    )

    static let nioEt5t = Vehicle(
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
        purchase: PurchaseInfo(
            nakedPrice: 266000,
            tax: 0,
            firstInsurance: 7420,
            regAndPlate: 120,
            accessories: 6380,
            totalLanded: 279920,
            estimatedResale: 218000,
            dealer: "蔚来中心 NIO House 上海中心",
            loanStatus: "整车买断 (免购置税)"
        ),
        healthScore: 98,
        nextAlert: "2万公里常规健检 · 剩余 3,580 km",
        fuelLogs: [
            FuelLog(date: "11-08", odo: 16420, deltaKm: 412, volume: 61.5, price: 0.92, cost: 56.6, consumption: 14.9, station: "蔚来三代换电站 · 漕河泾", full: true, note: "3分钟极速满电换电"),
            FuelLog(date: "10-29", odo: 16008, deltaKm: 430, volume: 62.0, price: 0.36, cost: 22.3, consumption: 14.4, station: "地下车库 7kW 家充桩 (谷电)", full: true, note: "22:00后谷电 0.36元/度"),
            FuelLog(date: "10-16", odo: 15578, deltaKm: 395, volume: 59.8, price: 0.36, cost: 21.5, consumption: 15.1, station: "地下车库 7kW 家充桩 (谷电)", full: true, note: "周末安吉露营满载"),
            FuelLog(date: "10-03", odo: 15183, deltaKm: 440, volume: 63.4, price: 1.15, cost: 72.9, consumption: 14.4, station: "蔚来 500kW 超充桩 · 嘉兴服务区", full: true, note: "高速 NOP+ 领航辅助")
        ],
        maintenanceParts: [
            MaintenancePart(name: "CN95 抗菌空调滤芯", spec: "原厂 HEPA 活性炭滤网", usedKm: 6420, limitKm: 15000, usedDays: 160, limitDays: 365, pct: 57, estCost: 280, lastDate: "2026-06-01 @ 10,000km"),
            MaintenancePart(name: "雨刮胶条 (前风挡+后掀背)", spec: "博世静音无骨雨刮", usedKm: 16420, limitKm: 20000, usedDays: 302, limitDays: 365, pct: 18, estCost: 190, lastDate: "出厂初装"),
            MaintenancePart(name: "前后减速器齿轮油", spec: "电驱专用低阻齿轮油", usedKm: 16420, limitKm: 60000, usedDays: 302, limitDays: 1095, pct: 73, estCost: 680, lastDate: "出厂初装"),
            MaintenancePart(name: "马牌 EcoContact 6 静音胎", spec: "245/45 R19 自修复轮胎", usedKm: 16420, limitKm: 45000, usedDays: 302, limitDays: 1095, pct: 64, estCost: 1350, lastDate: "胎纹深度 6.2mm")
        ],
        serviceRecords: [
            ServiceRecord(date: "2026-06-01", type: "10,000 km 年度无忧健检", shop: "蔚来服务中心 (上海莘庄)", odo: 10000, cost: 580, items: ["空调滤芯更换", "三电高压系统检测", "四轮定位校准"])
        ],
        insurance: InsuranceInfo(
            company: "太平洋新能源车险 · 智驾版",
            policyNo: "CPIC-EV-2026-099120",
            expireDate: "2027-01-11",
            daysRemaining: 62,
            ncdFactor: "0.85 (首年无出险优待)",
            totalPremium: 6420,
            compulsory: 950,
            commercial: 5470,
            coverages: [
                CoverageItem(name: "新能源汽车损失险 (含三电)", amount: "¥232,000", premium: "¥3,480"),
                CoverageItem(name: "第三者责任险", amount: "¥3,000,000", premium: "¥1,590"),
                CoverageItem(name: "外部电网故障损失险", amount: "含家充桩保障", premium: "¥180"),
                CoverageItem(name: "智能辅助泊车责任保障", amount: "¥50,000", premium: "¥220")
            ],
            compliance: ComplianceInfo(
                inspectionExpire: "2027-01-31 (绿牌免检申领)",
                violations: "0 条未处理 · 驾驶证 12 分满分",
                etcCard: "沪通卡新能源 ETC · 95折通行"
            )
        ),
        timeline: [
            TimelineEvent(date: "2026-11-08", cat: "加油", color: "emerald", title: "蔚来三代站极速换电 61.5 kWh", cost: "-¥56.6", odo: "16,420 km", tags: ["3分钟换电", "电耗 14.9kWh", "电池健康 100%"]),
            TimelineEvent(date: "2026-06-01", cat: "保养", color: "blue", title: "1万公里三电健检 & 空调滤更换", cost: "-¥580.0", odo: "10,000 km", tags: ["蔚来服务中心", "三电满分", "取送车服务"]),
            TimelineEvent(date: "2025-01-15", cat: "上路", color: "purple", title: "新能源绿牌上牌 & Thule车顶箱安装", cost: "-¥6,500.0", odo: "65 km", tags: ["沪AD·61920", "免征购置税", "家充桩报装完工"]),
            TimelineEvent(date: "2025-01-12", cat: "买车", color: "purple", title: "提车交付 · 蔚来 ET5T Touring", cost: "-¥273,420", odo: "8 km", tags: ["整车 ¥26.6万", "购置税 ¥0", "首年保险 ¥7,420"])
        ]
    )
}
