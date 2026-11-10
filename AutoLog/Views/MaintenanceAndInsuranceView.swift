import SwiftUI
import UIKit

struct MaintenanceAndInsuranceView: View {
    @EnvironmentObject var store: VehicleStore
    @State private var showClaimCalculatorAlert = false

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
    }

    // MARK: - Screen 4: Maintenance & Repair Section
    private var maintenanceSection: some View {
        VStack(spacing: 12) {
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
}
