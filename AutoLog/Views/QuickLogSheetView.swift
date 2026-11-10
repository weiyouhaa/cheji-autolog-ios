import SwiftUI

struct QuickLogSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss

    // Category 1: Fuel / Charging state
    @State private var fuelSubType: String = "95# 汽油"
    @State private var isFullTank: Bool = true
    @State private var odoText: String = ""
    @State private var costText: String = ""
    @State private var priceText: String = ""
    @State private var noteText: String = ""

    // Category 2: Maintenance state
    @State private var maintShopType: String = "品牌 4S 中心"
    @State private var maintCheckedIndices: Set<Int> = [0, 1]

    // Category 3: Repair state
    @State private var repairPartArea: String = "🛞 轮胎/轮毂"
    @State private var repairClaimType: String = "💳 自费维修"
    @State private var warrantyText: String = "门店质保 1年 / 2万公里"

    // Category 4: Insurance state
    @State private var insCompany: String = "🛡️ 中国平安车险"
    @State private var insCompulsoryText: String = "855"
    @State private var insCommercialText: String = "5680"
    @State private var insCheckedIndices: Set<Int> = [0, 1, 2, 3]

    // Category 5: On-Road Expense state
    @State private var roadExpenseType: String = "🅿️ 停车费/月租"

    // Category 6: Modification / Purchase state
    @State private var modSubType: String = "🛡️ 隐形车衣/改色膜"

    var car: Vehicle { store.currentVehicle }
    var cat: QuickLogCategory { store.selectedQuickLogCategory }

    private let insuranceOptions = [
        "机动车损失险 (车损)",
        "第三者责任险 (300万)",
        "医保外医疗费用险",
        "司乘人员责任险",
        "外部电网/三电附加险",
        "无限次道路救援+代驾"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Header Subtitle
                        Text(categorySubtitle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        // 6-Category Liquid Glass Pill Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(QuickLogCategory.allCases) { item in
                                let isSelected = (cat == item)
                                Button {
                                    withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                                        store.selectedQuickLogCategory = item
                                        applyCategoryDefaults(for: item)
                                    }
                                } label: {
                                    Text(item.displayTitle)
                                        .font(.system(size: 12, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 9)
                                        .background(
                                            Capsule(style: .continuous)
                                                .fill(isSelected ? AutoColor.accentOrange.opacity(0.22) : Color.primary.opacity(0.06))
                                                .overlay(
                                                    Capsule(style: .continuous)
                                                        .strokeBorder(isSelected ? AutoColor.accentOrange : Color.white.opacity(0.16), lineWidth: 1.1)
                                                )
                                        )
                                        .foregroundStyle(isSelected ? AutoColor.accentOrange : .secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        // Bespoke Dynamic Form Stage per Category
                        VStack(alignment: .leading, spacing: 12) {
                            switch cat {
                            case .fuel:
                                fuelFormSection
                            case .maintenance:
                                maintenanceFormSection
                            case .repair:
                                repairFormSection
                            case .insurance:
                                insuranceFormSection
                            case .onRoad:
                                onRoadFormSection
                            case .purchaseMod:
                                purchaseModFormSection
                            }
                        }
                        .liquidGlassCard(cornerRadius: 26)

                        // Live Formula & Impact Preview Bar
                        livePreviewBanner

                        // Submit Button
                        Button {
                            handleSubmit()
                        } label: {
                            Text(submitButtonTitle)
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 1.0, green: 0.44, blue: 0.24), AutoColor.accentOrange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            Capsule(style: .continuous)
                                                .strokeBorder(Color.white.opacity(0.42), lineWidth: 1)
                                        )
                                        .shadow(color: AutoColor.accentOrange.opacity(0.45), radius: 12, x: 0, y: 6)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("✍️ 记一笔 · 智能车务归档")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                applyCategoryDefaults(for: store.selectedQuickLogCategory)
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }

    // MARK: - 1. Fuel / Charging Form
    private var fuelFormSection: some View {
        let options = car.isEV
            ? ["7kW 家充桩(谷电)", "蔚来三代换电站", "品牌超充桩", "第三方快充"]
            : ["95# 汽油", "98# 汽油", "92# 汽油", "壳牌 V-Power"]

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(car.isEV ? "补能方式选择" : "油品标号与加注状态")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    isFullTank.toggle()
                } label: {
                    Text(isFullTank ? "☑️ 已满箱跳枪 (精准算油耗)" : "⬜ 未加满 (仅累计油费)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AutoColor.emerald)
                }
            }

            subOptionScroll(options: options, selection: $fuelSubType)

            HStack(spacing: 8) {
                inputField(label: "当前总里程 (km)", text: $odoText, keyboard: .numberPad)
                inputField(label: "实付金额 (¥)", text: $costText, keyboard: .decimalPad)
                inputField(label: "单价 (¥/\(car.isEV ? "度" : "升"))", text: $priceText, keyboard: .decimalPad)
            }

            inputField(label: "📍 \(car.isEV ? "充电站 / 换电站位置" : "加油站名称与优惠备注")", text: $noteText)
        }
    }

    // MARK: - 2. Maintenance Form (with Multi-Select Lifespan Reset)
    private var maintenanceFormSection: some View {
        let shopTypes = ["品牌 4S 中心", "途虎养车工场店", "专修连锁门店", "DIY 自购保养"]

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("选择服务门店类型")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("已选 \(maintCheckedIndices.count) 项保养工程")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AutoColor.cyan)
            }

            subOptionScroll(options: shopTypes, selection: $maintShopType)

            Text("☑️ 勾选本次更换项目 (提交后自动将寿命重置至 100%)")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                ForEach(Array(car.maintenanceParts.enumerated()), id: \.element.id) { idx, part in
                    let checked = maintCheckedIndices.contains(idx)
                    Button {
                        if checked {
                            maintCheckedIndices.remove(idx)
                        } else {
                            maintCheckedIndices.insert(idx)
                        }
                        let est = maintCheckedIndices.reduce(0.0) { acc, i in
                            acc + (i < car.maintenanceParts.count ? car.maintenanceParts[i].estCost : 300)
                        }
                        costText = String(format: "%.0f", max(180, est))
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: checked ? "checkmark.square.fill" : "square")
                                .foregroundStyle(checked ? AutoColor.emerald : .secondary)
                            Text(part.name)
                                .font(.system(size: 11, weight: .semibold))
                                .lineLimit(1)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(checked ? AutoColor.emerald.opacity(0.16) : Color.primary.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(checked ? AutoColor.emerald : Color.white.opacity(0.14), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack(spacing: 10) {
                inputField(label: "保养时总里程 (km)", text: $odoText, keyboard: .numberPad)
                inputField(label: "工时+材料总费用 (¥)", text: $costText, keyboard: .decimalPad)
            }

            inputField(label: "🏥 施工门店与机油/配件批次备注", text: $noteText)
        }
    }

    // MARK: - 3. Repair Form
    private var repairFormSection: some View {
        let areas = ["🛞 轮胎/轮毂", "🔋 电瓶/电路", "🎨 钣金喷漆", "⚙️ 底盘悬挂", "🪟 玻璃/车灯"]
        let claims = ["💳 自费维修", "🛡️ 厂家质保索赔(¥0)", "📑 走自己车损险", "⚖️ 对方全责赔付"]

        return VStack(alignment: .leading, spacing: 12) {
            Text("故障系统部位")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)
            subOptionScroll(options: areas, selection: $repairPartArea)

            Text("结算与保险理赔方式")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)
            subOptionScroll(options: claims, selection: $repairClaimType)
                .onChange(of: repairClaimType) { _, newValue in
                    if newValue.contains("¥0") || newValue.contains("对方") {
                        costText = "0"
                    } else if costText == "0" {
                        costText = "260"
                    }
                }

            HStack(spacing: 10) {
                inputField(label: "送修时总里程 (km)", text: $odoText, keyboard: .numberPad)
                inputField(label: "自付维修金额 (¥)", text: $costText, keyboard: .decimalPad)
            }

            HStack(spacing: 10) {
                inputField(label: "故障现象与处理方案", text: $noteText)
                inputField(label: "配件质保期承诺", text: $warrantyText)
            }
        }
    }

    // MARK: - 4. Insurance Form
    private var insuranceFormSection: some View {
        let companies = ["🛡️ 中国平安车险", "🌊 太平洋产险", "🏛️ 人保财险 PICC", "⚡ 官方合作智驾险"]

        return VStack(alignment: .leading, spacing: 12) {
            Text("选择承保保险公司")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)
            subOptionScroll(options: companies, selection: $insCompany)

            HStack {
                Text("商业险投保组合勾选")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("NCD 0.7 连续未出险优待")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AutoColor.emerald)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                ForEach(Array(insuranceOptions.enumerated()), id: \.offset) { idx, title in
                    let checked = insCheckedIndices.contains(idx)
                    Button {
                        if checked {
                            insCheckedIndices.remove(idx)
                        } else {
                            insCheckedIndices.insert(idx)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: checked ? "checkmark.square.fill" : "square")
                                .foregroundStyle(checked ? AutoColor.emerald : .secondary)
                            Text(title)
                                .font(.system(size: 11, weight: .semibold))
                                .lineLimit(1)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(checked ? AutoColor.emerald.opacity(0.16) : Color.primary.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(checked ? AutoColor.emerald : Color.white.opacity(0.14), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack(spacing: 10) {
                inputField(label: "交强险+车船税 (¥)", text: $insCompulsoryText, keyboard: .decimalPad)
                inputField(label: "商业险合计 (¥)", text: $insCommercialText, keyboard: .decimalPad)
            }

            inputField(label: "🎁 保单生效日与赠送权益包备注", text: $noteText)
        }
    }

    // MARK: - 5. On-Road Expense Form
    private var onRoadFormSection: some View {
        let roadTypes = ["🅿️ 停车费/月租", "🛣️ 高速 ETC 通行", "🧼 洗车/打蜡精洗", "🚦 违章罚款记分", "🔍 年检审车"]

        return VStack(alignment: .leading, spacing: 12) {
            Text("日常上路与车务细分类型 (点击切换预设)")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)

            subOptionScroll(options: roadTypes, selection: $roadExpenseType)
                .onChange(of: roadExpenseType) { _, newType in
                    applyRoadPreset(newType)
                }

            HStack(spacing: 10) {
                inputField(label: "发生金额 (¥)", text: $costText, keyboard: .decimalPad)
                inputField(
                    label: roadExpenseType.contains("违章") ? "驾驶证记分 (分)" : "当前总里程 (km)",
                    text: $odoText,
                    keyboard: .numberPad
                )
            }

            inputField(label: "📍 地点 / 高速路段 / 详细事项", text: $noteText)
        }
    }

    // MARK: - 6. Modification / Purchase Asset Form
    private var purchaseModFormSection: some View {
        let modTypes = ["🛡️ 隐形车衣/改色膜", "🛞 轮毂/卡钳/避震", "📷 记录仪/脚垫车品", "🎖️ 购置税/上牌落户"]

        return VStack(alignment: .leading, spacing: 12) {
            Text("改装升级与购车项目归类")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(.secondary)

            subOptionScroll(options: modTypes, selection: $modSubType)
                .onChange(of: modSubType) { _, newMod in
                    applyModPreset(newMod)
                }

            HStack(spacing: 10) {
                inputField(label: "投入金额 (¥)", text: $costText, keyboard: .decimalPad)
                inputField(label: "安装/办理时里程 (km)", text: $odoText, keyboard: .numberPad)
            }

            inputField(label: "✨ 品牌型号、施工门店与车管所备案状态", text: $noteText)
        }
    }

    // MARK: - Live Calculation Preview Banner
    private var livePreviewBanner: some View {
        HStack {
            switch cat {
            case .fuel:
                let odo = Int(odoText) ?? (car.odometer + 510)
                let cost = Double(costText) ?? 345.0
                let price = max(0.01, Double(priceText) ?? 7.96)
                let delta = max(50, odo - car.odometer)
                let liters = cost / price
                let cons = (liters / Double(delta)) * 100.0
                let perKm = cost / Double(delta)
                VStack(alignment: .leading, spacing: 3) {
                    Text(String(format: "⚡ 自动折算：加注 %.1f %@ · 阶段行驶 +%d km", liters, car.isEV ? "kWh" : "L", delta))
                        .font(.system(size: 11.5, weight: .semibold))
                    Text(String(format: "本箱实测 %.2f %@ (折合 ¥%.2f/km)", cons, car.consumptionUnit, perKm))
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(AutoColor.emerald)
                }
            case .maintenance:
                let cost = Double(costText) ?? 1180
                VStack(alignment: .leading, spacing: 3) {
                    Text("🔄 提交后将重置 \(maintCheckedIndices.count) 项配件寿命进度条至 100%")
                        .font(.system(size: 11.5, weight: .semibold))
                    Text("下次保养预警里程：\((car.odometer + 10000).formatted()) km · 本次合计 ¥\(Int(cost))")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(AutoColor.cyan)
                }
            case .repair:
                let cost = Double(costText) ?? 260
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(repairPartArea) · 自付 ¥\(Int(cost))")
                        .font(.system(size: 11.5, weight: .semibold))
                    Text(repairClaimType.contains("车损险") ? "⚠️ 走车损险：预计次年保费上浮约 ¥1,420" : "✅ 不动用商业险：次年保费维持 NCD 最优折扣")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(repairClaimType.contains("车损险") ? AutoColor.amber : AutoColor.emerald)
                }
            case .insurance:
                let comp = Double(insCompulsoryText) ?? 855
                let comm = Double(insCommercialText) ?? 5680
                let total = comp + comm
                VStack(alignment: .leading, spacing: 3) {
                    Text("🛡️ 年度总保费 ¥\(Int(total).formatted()) (含 \(insCheckedIndices.count) 项商业险)")
                        .font(.system(size: 11.5, weight: .semibold))
                    Text(String(format: "折合日均 ¥%.1f/天 · 提交后刷新 365 天续保倒计时", total / 365.0))
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(AutoColor.emerald)
                }
            case .onRoad:
                let cost = Double(costText) ?? 50
                VStack(alignment: .leading, spacing: 3) {
                    Text("📊 归入「\(roadExpenseType)」日常车务账本")
                        .font(.system(size: 11.5, weight: .semibold))
                    Text("累计停车/ETC/车务支出将更新为 ¥\(Int(car.totalOtherSpend + cost).formatted())")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(AutoColor.purple)
                }
            case .purchaseMod:
                let cost = Double(costText) ?? 6800
                VStack(alignment: .leading, spacing: 3) {
                    Text("✨ 归入「\(modSubType)」固定资产与装潢档案")
                        .font(.system(size: 11.5, weight: .semibold))
                    Text(String(format: "车辆落地与改装总投入将更新为 ¥%.2f万", (car.purchase.totalLanded + cost) / 10000.0))
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(AutoColor.purple)
                }
            }
            Spacer()
        }
        .monospacedDigit()
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AutoColor.emerald.opacity(0.12))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(AutoColor.emerald.opacity(0.32), lineWidth: 1))
        )
    }

    // MARK: - Helpers
    private func subOptionScroll(options: [String], selection: Binding<String>) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(options, id: \.self) { opt in
                    let isSel = selection.wrappedValue == opt
                    Button {
                        selection.wrappedValue = opt
                    } label: {
                        Text(opt)
                            .font(.system(size: 11.5, weight: .bold))
                            .padding(.horizontal, 11)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(isSel ? AutoColor.cyan.opacity(0.2) : Color.primary.opacity(0.05))
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .strokeBorder(isSel ? AutoColor.cyan : Color.white.opacity(0.14), lineWidth: 1)
                                    )
                            )
                            .foregroundStyle(isSel ? AutoColor.cyan : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func inputField(label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10.5, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            TextField("", text: text)
                .keyboardType(keyboard)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .padding(.horizontal, 11)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(Color.primary.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                        )
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var categorySubtitle: String {
        switch cat {
        case .fuel:
            return car.isEV
                ? "记录家充谷电、超充或换电明细 · 自动计算百公里电耗"
                : "记录加油升数、油品标号与跳枪状态 · 自动折算满箱油耗"
        case .maintenance:
            return "勾选本次更换的保养项目 · 提交后自动将对应配件寿命重置为 100%"
        case .repair:
            return "记录故障部位、维修方案、质保期限与理赔结算方式"
        case .insurance:
            return "录入交强险、商业险保费明细与未出险折扣，自动激活 365 天倒计时"
        case .onRoad:
            return "记录停车费、高速 ETC 通行、精洗美容、违章罚款或年检审车"
        case .purchaseMod:
            return "记录隐形车衣、改色膜、轮毂卡钳改装、车载精品或购车落户税费"
        }
    }

    private var submitButtonTitle: String {
        switch cat {
        case .fuel: return car.isEV ? "⚡ 确认记入补能账本 (更新电耗曲线)" : "⛽ 确认记入加油账本 (更新油耗曲线)"
        case .maintenance: return "🔧 确认归档保养工单 & 重置配件寿命"
        case .repair: return "🛠️ 确认记入故障维修档案"
        case .insurance: return "🛡️ 确认归档电子保单 (刷新保障倒计时)"
        case .onRoad: return "🛣️ 确认记入日常上路与车务账本"
        case .purchaseMod: return "✨ 确认记入车辆固定资产与改装档案"
        }
    }

    private func applyCategoryDefaults(for category: QuickLogCategory) {
        switch category {
        case .fuel:
            fuelSubType = car.isEV ? "7kW 家充桩(谷电)" : "95# 汽油"
            odoText = "\(car.odometer + 510)"
            costText = car.isEV ? "48.5" : "345.0"
            priceText = car.isEV ? "0.78" : "7.96"
            noteText = car.isEV ? "蔚来三代换电站 · 漕河泾开发区" : "壳牌 V-Power 世纪大道站"
        case .maintenance:
            odoText = "\(car.odometer)"
            let est = maintCheckedIndices.reduce(0.0) { acc, i in
                acc + (i < car.maintenanceParts.count ? car.maintenanceParts[i].estCost : 300)
            }
            costText = String(format: "%.0f", max(580, est))
            noteText = car.isEV ? "蔚来服务中心 · 年度三电健检" : "上海宝诚宝马 4S · 0W-20全合成保养"
        case .repair:
            odoText = "\(car.odometer)"
            costText = "260"
            noteText = "右后轮扎钉 · 蘑菇钉内补+动平衡"
        case .insurance:
            insCompulsoryText = car.isEV ? "950" : "855"
            insCommercialText = car.isEV ? "5470" : "5680"
            noteText = "赠3次酒后代驾 + 2次免费洗车 + 免费年检代办"
        case .onRoad:
            applyRoadPreset(roadExpenseType)
        case .purchaseMod:
            applyModPreset(modSubType)
        }
    }

    private func applyRoadPreset(_ type: String) {
        if type.contains("停车") {
            costText = "40"
            odoText = "\(car.odometer)"
            noteText = "上海国金中心 IFC 地下车库临停 4小时"
        } else if type.contains("ETC") {
            costText = "85"
            odoText = "\(car.odometer)"
            noteText = "沪昆高速 G60 枫泾收费站 ETC 95折通行"
        } else if type.contains("洗车") {
            costText = "68"
            odoText = "\(car.odometer)"
            noteText = "双手桶中性泡沫精洗 + 轮毂铁粉去除"
        } else if type.contains("违章") {
            costText = "200"
            odoText = "1"
            noteText = "实线变道 · 罚款 ¥200"
        } else {
            costText = "260"
            odoText = "\(car.odometer)"
            noteText = "机动车安全技术与尾气上线年检"
        }
    }

    private func applyModPreset(_ mod: String) {
        odoText = "\(car.odometer)"
        if mod.contains("车衣") {
            costText = "6800"
            noteText = "XPEL LUX Plus 8.5mil 隐形车衣 · 10年电子质保"
        } else if mod.contains("轮毂") {
            costText = "9500"
            noteText = "BBS 19寸锻造轮毂 + Brembo 六活塞卡钳 (已备案)"
        } else if mod.contains("记录仪") {
            costText = "1280"
            noteText = "盯盯拍 4K 隐藏式行车记录仪 + 全TPE脚垫"
        } else {
            costText = "500"
            noteText = "车管所选号牌证费 + 固封螺丝安装"
        }
    }

    private func handleSubmit() {
        switch cat {
        case .fuel:
            store.submitFuelLog(
                odo: Int(odoText) ?? (car.odometer + 500),
                cost: Double(costText) ?? 345,
                price: Double(priceText) ?? 7.96,
                subType: fuelSubType,
                isFullTank: isFullTank,
                stationNote: noteText
            )
        case .maintenance:
            store.submitMaintenance(
                odo: Int(odoText) ?? car.odometer,
                cost: Double(costText) ?? 1180,
                shopType: maintShopType,
                checkedIndices: maintCheckedIndices,
                shopNote: noteText
            )
        case .repair:
            store.submitRepair(
                odo: Int(odoText) ?? car.odometer,
                cost: Double(costText) ?? 260,
                partArea: repairPartArea,
                claimType: repairClaimType,
                symptomNote: noteText,
                warrantyNote: warrantyText
            )
        case .insurance:
            let cleanCompany = insCompany.components(separatedBy: " ").last ?? insCompany
            let items = insCheckedIndices.sorted().compactMap { $0 < insuranceOptions.count ? insuranceOptions[$0] : nil }
            store.submitInsurance(
                company: cleanCompany,
                compulsory: Double(insCompulsoryText) ?? 855,
                commercial: Double(insCommercialText) ?? 5680,
                checkedItems: items,
                benefitNote: noteText
            )
        case .onRoad:
            store.submitRoadExpense(
                expenseType: roadExpenseType,
                cost: Double(costText) ?? 50,
                odoOrPoints: Int(odoText) ?? 0,
                detailNote: noteText
            )
        case .purchaseMod:
            store.submitModification(
                modType: modSubType,
                cost: Double(costText) ?? 6800,
                odo: Int(odoText) ?? car.odometer,
                detailNote: noteText
            )
        }
        dismiss()
    }
}
