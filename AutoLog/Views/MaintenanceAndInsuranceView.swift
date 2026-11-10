import SwiftUI
import UIKit

struct MaintenanceAndInsuranceView: View {
    @EnvironmentObject var store: VehicleStore
    @State private var showClaimCalculatorAlert = false
    @State private var selectedTireForEdit: TireWheelStatus? = nil
    @State private var showAccidentSOSSheet = false

    var car: Vehicle { store.currentVehicle }
    var isInsuranceMode: Bool { store.activeTab == .insurance }

    var body: some View {
        VStack(spacing: 12) {
            // Top Liquid Glass Segmented Switcher
            HStack(spacing: 4) {
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        store.activeTab = .maintenance
                    }
                } label: {
                    Text("🔧 保养与故障维修")
                        .font(.system(size: 12.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(!isInsuranceMode ? Color.primary.opacity(0.16) : Color.clear)
                        )
                        .foregroundStyle(!isInsuranceMode ? .primary : .secondary)
                }
                .buttonStyle(.plain)

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        store.activeTab = .insurance
                    }
                } label: {
                    Text("🛡️ 车险保单与上路合规")
                        .font(.system(size: 12.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(isInsuranceMode ? Color.primary.opacity(0.16) : Color.clear)
                        )
                        .foregroundStyle(isInsuranceMode ? .primary : .secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(4)
            .background(
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(Capsule().strokeBorder(Color.white.opacity(0.2), lineWidth: 1))
            )

            if !isInsuranceMode {
                maintenanceSection
            } else {
                insuranceSection
            }
        }
        .alert("🧮 出险次年保费涨价试算", isPresented: $showClaimCalculatorAlert) {
            Button("去记一笔出险/维修") {
                store.openQuickLog(.repair)
            }
            Button("知道了", role: .cancel) {}
        } message: {
            Text("当前享 \(car.insurance.ncdFactor)。\n• 若本年度出险 1 次：次年 NCD 折扣恢复为 1.0，预计保费上浮约 ¥1,420（故 ¥1,500 以内小刮蹭建议自费维修）；\n• 若出险 2 次：次年保费预计上浮约 ¥2,850。")
        }
        .sheet(item: $selectedTireForEdit) { tire in
            TireTuningSheetView(tire: tire)
                .environmentObject(store)
                .presentationDetents([.height(360)])
                .presentationCornerRadius(32)
        }
        .sheet(isPresented: $showAccidentSOSSheet) {
            AccidentSOSSheetView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationCornerRadius(36)
        }
    }

    // MARK: - Screen 4: Maintenance & Repair Section
    private var maintenanceSection: some View {
        VStack(spacing: 12) {
            // 0. Iteration 01: 4-Wheel TPMS & Tread Depth Matrix Card
            tireMatrixCard

            // 1. Component Lifespan Dual-Progress Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🛠️ 关键易损件寿命监控 (里程×时间)")
                        .font(.system(size: 14, weight: .bold))
                    Spacer()
                    Button {
                        store.openQuickLog(.maintenance)
                    } label: {
                        Text("+ 保养重置")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                VStack(spacing: 9) {
                    ForEach(car.maintenanceParts) { part in
                        let barColor = part.pct <= 25 ? AutoColor.amber : AutoColor.emerald
                        Button {
                            store.openQuickLog(.maintenance)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(barColor)
                                            .frame(width: 7, height: 7)
                                            .shadow(color: barColor, radius: 3)
                                        Text(part.name)
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    Spacer()
                                    Text("剩余 \(part.pct)%")
                                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                                        .foregroundStyle(barColor)
                                        .monospacedDigit()
                                }

                                Text("规格: \(part.spec)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.tertiary)

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.primary.opacity(0.14))
                                        Capsule()
                                            .fill(barColor)
                                            .frame(width: geo.size.width * CGFloat(max(4, min(100, part.pct))) / 100.0)
                                    }
                                }
                                .frame(height: 6)
                                .padding(.vertical, 2)

                                HStack {
                                    Text("已跑 \(part.usedKm.formatted()) / \(part.limitKm.formatted()) km")
                                    Spacer()
                                    Text("上次: \(part.lastDate)")
                                        .lineLimit(1)
                                }
                                .font(.system(size: 10.5))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.primary.opacity(0.045))
                                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Color.white.opacity(0.14), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .liquidGlassCard(cornerRadius: 28)

            // 2. Historical Service & Repair Orders
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("📋 历史保养与故障维修工单")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Button {
                        store.openQuickLog(.repair)
                    } label: {
                        Text("+ 记维修")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                VStack(spacing: 10) {
                    ForEach(car.serviceRecords) { rec in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(rec.type)
                                    .font(.system(size: 13.5, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("¥\(Int(rec.cost).formatted())")
                                    .font(.system(size: 13.5, weight: .heavy, design: .rounded))
                                    .foregroundStyle(AutoColor.cyan)
                                    .monospacedDigit()
                            }

                            Text("📅 \(rec.date) · 📍 \(rec.shop) · 🛣️ \(rec.odo.formatted()) km")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 5) {
                                    ForEach(rec.items, id: \.self) { item in
                                        Text(item)
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 3)
                                            .background(Color.primary.opacity(0.07), in: Capsule())
                                    }
                                    Text("📎 电子工单")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundStyle(AutoColor.cyan)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 3)
                                        .background(AutoColor.cyan.opacity(0.14), in: Capsule())
                                }
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.primary.opacity(0.045))
                                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Color.white.opacity(0.13), lineWidth: 1))
                        )
                    }
                }
            }
            .liquidGlassCard(cornerRadius: 28)
        }
    }

    // MARK: - Screen 5: Insurance & On-Road Compliance Section
    private var insuranceSection: some View {
        let ins = car.insurance
        return VStack(spacing: 12) {
            // 0. Iteration 06: Emergency SOS & 6-Angle Evidence Guide Card
            emergencySOSCard

            // 1. Insurance Policy Wallet Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("🛡️ \(ins.company)")
                            .font(.system(size: 15, weight: .heavy))
                        Text("保单号: \(ins.policyNo)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        store.openQuickLog(.insurance)
                    } label: {
                        Text("+ 续保/出险")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                // 3-Column Metrics
                HStack(spacing: 8) {
                    insBox(label: "年度总保费", value: "¥\(Int(ins.totalPremium).formatted())", color: .primary)
                    insBox(label: "交强 + 商业", value: "¥\(Int(ins.compulsory))+\(Int(ins.commercial))", color: .primary)
                    insBox(label: "剩余保障期", value: "\(ins.daysRemaining) 天", color: AutoColor.emerald)
                }

                // Coverage Breakdown
                VStack(spacing: 6) {
                    ForEach(ins.coverages) { cov in
                        HStack {
                            Text(cov.name)
                                .font(.system(size: 11.5, weight: .medium))
                            Spacer()
                            Text("保额 \(cov.amount)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text(cov.premium)
                                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                .frame(minWidth: 48, alignment: .trailing)
                        }
                        .monospacedDigit()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.primary.opacity(0.045))
                                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                        )
                    }
                }

                HStack(spacing: 8) {
                    Button {
                        store.showToast("📄 已调阅 \(ins.policyNo) 电子保单原件")
                    } label: {
                        Text("📄 电子保单原件")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.primary.opacity(0.08), in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Button {
                        showClaimCalculatorAlert = true
                    } label: {
                        Text("🧮 出险涨价试算")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(AutoColor.emerald.opacity(0.18), in: Capsule())
                            .foregroundStyle(AutoColor.emerald)
                    }
                    .buttonStyle(.plain)
                }
            }
            .liquidGlassCard(cornerRadius: 28, tint: AutoColor.emerald)

            // 2. Digital Glovebox & On-Road Compliance
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🪪 上路合规 & 数字手套箱")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Button {
                        store.openQuickLog(.onRoad)
                    } label: {
                        Text("+ 记停车/车务")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                VStack(spacing: 9) {
                    gloveboxRow(
                        title: "🔍 年检与免检标志",
                        subtitle: ins.compliance.inspectionExpire,
                        badge: "正常",
                        badgeColor: AutoColor.emerald
                    )
                    gloveboxRow(
                        title: "🚦 违章与驾照记分监控",
                        subtitle: ins.compliance.violations,
                        badge: "0 违章",
                        badgeColor: AutoColor.emerald
                    )
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("🛣️ 高速 ETC 通行卡")
                                .font(.system(size: 12.5, weight: .bold))
                            Text(ins.compliance.etcCard)
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            store.openQuickLog(.onRoad)
                        } label: {
                            Text("记通行 ›")
                                .font(.system(size: 11.5, weight: .bold))
                                .foregroundStyle(AutoColor.accentOrange)
                        }
                    }
                    .padding(11)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.primary.opacity(0.045))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                    )

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("🔢 车架号 VIN & 发动机号")
                                .font(.system(size: 12.5, weight: .bold))
                            Text("\(car.vin) · \(car.engineNo)")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            UIPasteboard.general.string = car.vin
                            store.showToast("✅ 已复制车架号 VIN 至系统剪贴板")
                        } label: {
                            Text("复制")
                                .font(.system(size: 11.5, weight: .bold))
                                .foregroundStyle(AutoColor.cyan)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AutoColor.cyan.opacity(0.15), in: Capsule())
                        }
                    }
                    .padding(11)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.primary.opacity(0.045))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                    )
                }
            }
            .liquidGlassCard(cornerRadius: 28)
        }
    }

    private func insBox(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(9)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.primary.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(Color.white.opacity(0.14), lineWidth: 1))
        )
    }

    private func gloveboxRow(title: String, subtitle: String, badge: String, badgeColor: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12.5, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            StatusChip(text: badge, color: badgeColor)
        }
        .padding(11)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.primary.opacity(0.045))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
        )
    }

    // MARK: - Iteration 06: Emergency SOS & Accident Evidence Guide Card
    private var emergencySOSCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AutoColor.rose.opacity(0.22))
                    .frame(width: 44, height: 44)
                Text("🆘")
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("事故应急救援 & 现场 6 图取证向导")
                    .font(.system(size: 13.5, weight: .heavy))
                Text("刮蹭/追尾不慌 · 标准 6 机位拍照清单 + 一键报案专线")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                showAccidentSOSSheet = true
            } label: {
                Text("打开急救包 ›")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(AutoColor.rose, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .liquidGlassCard(cornerRadius: 26, tint: AutoColor.rose)
    }

    // MARK: - Iteration 01: 4-Wheel TPMS & Tread Matrix Card
    private var tireMatrixCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🛞 四轮胎压与胎纹透视矩阵 (TPMS)")
                    .font(.system(size: 14.5, weight: .bold))
                Spacer()
                Button {
                    store.inflateAllTiresToStandard()
                } label: {
                    Text("⚡ 一键充气校准")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AutoColor.cyan)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4.5)
                        .background(AutoColor.cyan.opacity(0.15), in: Capsule())
                }
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(car.tires) { tire in
                    let isLowPressure = tire.pressureBar < 2.38
                    let stateColor = isLowPressure ? AutoColor.amber : AutoColor.emerald

                    Button {
                        selectedTireForEdit = tire
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(tire.positionName)
                                    .font(.system(size: 12, weight: .bold))
                                Spacer()
                                if tire.patchCount > 0 {
                                    Text("补胎×\(tire.patchCount)")
                                        .font(.system(size: 9.5, weight: .bold))
                                        .foregroundStyle(AutoColor.rose)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(AutoColor.rose.opacity(0.16), in: Capsule())
                                } else {
                                    Circle()
                                        .fill(stateColor)
                                        .frame(width: 7, height: 7)
                                }
                            }

                            HStack(alignment: .firstTextBaseline, spacing: 3) {
                                Text(String(format: "%.2f", tire.pressureBar))
                                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                                    .foregroundStyle(stateColor)
                                    .monospacedDigit()
                                Text("Bar")
                                    .font(.system(size: 10.5, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(tire.tempC)°C")
                                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }

                            HStack {
                                Text(String(format: "胎纹 %.1fmm", tire.treadMm))
                                Spacer()
                                Text("调校 ›")
                                    .foregroundStyle(AutoColor.cyan)
                            }
                            .font(.system(size: 10.5, weight: .semibold))
                            .foregroundStyle(.secondary)
                        }
                        .padding(11)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.primary.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .strokeBorder(isLowPressure ? AutoColor.amber.opacity(0.55) : Color.white.opacity(0.14), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .liquidGlassCard(cornerRadius: 28)
    }
}

struct TireTuningSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss
    let tire: TireWheelStatus

    @State private var pressure: Double = 2.50
    @State private var tread: Double = 5.5
    @State private var patchCount: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                VStack(alignment: .leading, spacing: 14) {
                    Text("规格：\(tire.brandSpec)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)

                    VStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("冷车胎压 (Bar)")
                                    .font(.system(size: 12, weight: .bold))
                                Spacer()
                                Text(String(format: "%.2f Bar", pressure))
                                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                                    .foregroundStyle(AutoColor.emerald)
                                    .monospacedDigit()
                            }
                            Slider(value: $pressure, in: 1.8...3.2, step: 0.05)
                                .tint(AutoColor.emerald)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("剩余胎纹深度 (安全线 ≥ 1.6mm)")
                                    .font(.system(size: 12, weight: .bold))
                                Spacer()
                                Text(String(format: "%.1f mm", tread))
                                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                                    .foregroundStyle(AutoColor.cyan)
                                    .monospacedDigit()
                            }
                            Slider(value: $tread, in: 1.5...8.0, step: 0.1)
                                .tint(AutoColor.cyan)
                        }

                        Stepper("历史蘑菇钉补胎次数：\(patchCount) 次", value: $patchCount, in: 0...10)
                            .font(.system(size: 12.5, weight: .bold))
                    }
                    .liquidGlassCard(cornerRadius: 24)

                    Button {
                        store.updateSingleTire(id: tire.id, pressureBar: pressure, treadMm: tread, patchCount: patchCount)
                        dismiss()
                    } label: {
                        Text("保存「\(tire.positionName)」调校数据")
                            .font(.system(size: 14.5, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(AutoColor.accentOrange, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
            .navigationTitle("🛞 \(tire.positionName) 调校")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
            .onAppear {
                pressure = tire.pressureBar
                tread = tire.treadMm
                patchCount = tire.patchCount
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }
}

struct AccidentSOSSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss
    @State private var checkedAngles: Set<Int> = [0, 1]

    private let photoAngles: [(title: String, desc: String)] = [
        ("1. 前侧 45° 全景照", "需拍清两车相对位置、车道线及双方前车牌"),
        ("2. 后侧 45° 全景照", "需拍清后方标线、刹车轨迹及双方后车牌"),
        ("3. 碰撞接触点特写", "近距离拍清掉漆、凹陷或碎裂部位细节"),
        ("4. 本车与对方车架号 VIN", "前挡风玻璃左下角或 B 柱铭牌"),
        ("5. 对方行驶证与驾驶证", "正副本均需拍清，核对是否在有效期内"),
        ("6. 交管 12123 责任认定书", "轻微事故拍照后先挪车至安全区再走快处")
    ]

    private let hotlines: [(name: String, number: String)] = [
        ("🚓 交警交通事故报警", "122"),
        ("🛣️ 全国高速公路救援", "12122"),
        ("🛡️ 中国平安产险报案", "95511"),
        ("🌊 太平洋产险报案", "95500"),
        ("🏛️ 人保财险 PICC 报案", "95518")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Step 1: Safety Warning
                        HStack(spacing: 10) {
                            Text("⚠️")
                                .font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("第一步：开启双闪 + 放置三角警示牌")
                                    .font(.system(size: 13.5, weight: .heavy))
                                Text("常规道路车后 50～100米，高速公路 150米外（夜间250米），车上人员立即撤离至护栏外！")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .liquidGlassCard(cornerRadius: 24, tint: AutoColor.amber)

                        // Step 2: 6-Angle Photo Checklist
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("📷 现场出险 6 机位标准取证清单")
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Text("已取证 \(checkedAngles.count)/6")
                                    .font(.system(size: 11.5, weight: .bold))
                                    .foregroundStyle(AutoColor.emerald)
                            }

                            ForEach(Array(photoAngles.enumerated()), id: \.offset) { idx, item in
                                let isDone = checkedAngles.contains(idx)
                                Button {
                                    if isDone { checkedAngles.remove(idx) }
                                    else { checkedAngles.insert(idx) }
                                } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 17))
                                            .foregroundStyle(isDone ? AutoColor.emerald : .secondary)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.title)
                                                .font(.system(size: 12.5, weight: .bold))
                                            Text(item.desc)
                                                .font(.system(size: 10.5))
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(isDone ? AutoColor.emerald.opacity(0.14) : Color.primary.opacity(0.05))
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .liquidGlassCard(cornerRadius: 26)

                        // Step 3: Emergency Hotlines & Policy Info
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("📞 一键救援与保险报案专线")
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = "\(store.currentVehicle.plate) 保单号:\(store.currentVehicle.insurance.policyNo) VIN:\(store.currentVehicle.vin)"
                                    store.showToast("✅ 已复制本车牌号、保单号与 VIN 码")
                                } label: {
                                    Text("复制本车报案三要素")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(AutoColor.cyan)
                                }
                            }

                            ForEach(hotlines, id: \.number) { line in
                                HStack {
                                    Text(line.name)
                                        .font(.system(size: 12.5, weight: .bold))
                                    Spacer()
                                    Button {
                                        UIPasteboard.general.string = line.number
                                        store.showToast("📞 已复制救援号码 \(line.number)")
                                    } label: {
                                        Text("拨打 \(line.number)")
                                            .font(.system(size: 11.5, weight: .heavy, design: .rounded))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(AutoColor.rose, in: Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .liquidGlassCard(cornerRadius: 26)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("🆘 事故应急与取证向导")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }
}
