import SwiftUI

struct CockpitHomeView: View {
    @EnvironmentObject var store: VehicleStore

    var car: Vehicle { store.currentVehicle }

    var body: some View {
        VStack(spacing: 12) {
            // 1. Hero Vehicle Spatial Liquid Glass Card
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(car.name)
                            .font(.system(size: 19, weight: .heavy, design: .rounded))
                        HStack(spacing: 6) {
                            Text(car.colorName)
                            Text("·")
                            Text("陪伴 \(car.daysOwned) 天")
                        }
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundStyle(.secondary)
                    }
                    Spacer()
                    StatusChip(text: "车况 \(car.healthScore)分", color: AutoColor.emerald, showDot: true)
                }

                // Vector Car Silhouette with Ambient Glow
                ZStack {
                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [AutoColor.accentOrange.opacity(0.36), .clear],
                                center: .center,
                                startRadius: 5,
                                endRadius: 115
                            )
                        )
                        .frame(width: 230, height: 38)
                        .offset(y: 22)

                    CarSilhouetteView(isEV: car.isEV)
                        .frame(width: 260, height: 78)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)

                // Odometer Capsule Strip
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("总行驶里程 ODOMETER")
                            .font(.system(size: 9.5, weight: .bold))
                            .foregroundStyle(.secondary)
                            .tracking(0.6)

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(car.odometer.formatted())
                                .font(.system(size: 23, weight: .heavy, design: .monospaced))
                            Text("km")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 3) {
                        Text(String(format: "日均 %.1f km", car.dailyKm))
                            .font(.system(size: 12.5, weight: .bold, design: .rounded))
                            .foregroundStyle(AutoColor.accentOrange)
                        Text(String(format: "全周期 ¥%.1f/天 (含折旧)", car.dailyHoldingCost))
                            .font(.system(size: 10.5, weight: .medium))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                        )
                )
            }
            .liquidGlassCard(cornerRadius: 30, tint: AutoColor.accentOrange)

            // 2. 2x2 Liquid Glass Telemetry Bento Grid
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                // Tile 1: Fuel / Energy
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        store.activeTab = .fuel
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("⛽")
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                                .background(AutoColor.amber.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                            Text("优于同系 12%")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(AutoColor.emerald)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(AutoColor.emerald.opacity(0.16), in: Capsule())
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.2f", car.avgConsumption))
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                            Text(car.consumptionUnit)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 2)

                        Text(car.isEV ? "实测综合百公里电耗" : "实测满箱百公里油耗")
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundStyle(.secondary)

                        HStack {
                            Text(String(format: "折合 ¥%.2f/km", car.energyCostPerKm))
                            Spacer()
                            Text("曲线 ›")
                        }
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 2)
                    }
                    .foregroundStyle(.primary)
                    .liquidGlassCard(cornerRadius: 26)
                }
                .buttonStyle(.plain)

                // Tile 2: Maintenance Health
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        store.activeTab = .maintenance
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("🔧")
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                                .background(AutoColor.cyan.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                            Text("寿命监控")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(AutoColor.amber)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(AutoColor.amber.opacity(0.16), in: Capsule())
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(car.isEV ? "3,580" : "840")
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                            Text("km后")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 2)

                        Text(car.isEV ? "下次常规三电健检" : "四轮换位 & 动平衡")
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundStyle(.secondary)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.primary.opacity(0.14))
                                Capsule()
                                    .fill(AutoColor.amber)
                                    .frame(width: geo.size.width * (car.isEV ? 0.65 : 0.84))
                            }
                        }
                        .frame(height: 6)
                        .padding(.top, 6)
                    }
                    .foregroundStyle(.primary)
                    .liquidGlassCard(cornerRadius: 26)
                }
                .buttonStyle(.plain)

                // Tile 3: Insurance & Compliance
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        store.activeTab = .insurance
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("🛡️")
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                                .background(AutoColor.emerald.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                            Text("0 违章")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(AutoColor.cyan)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(AutoColor.cyan.opacity(0.16), in: Capsule())
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(car.insurance.daysRemaining)")
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                            Text("天到期")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 2)

                        Text(car.insurance.company.components(separatedBy: "·").first ?? car.insurance.company)
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)

                        HStack {
                            Text("\(car.insurance.ncdFactor.components(separatedBy: " ").first ?? "0.7") 折扣")
                            Spacer()
                            Text("保单 ›")
                        }
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 2)
                    }
                    .foregroundStyle(.primary)
                    .liquidGlassCard(cornerRadius: 26)
                }
                .buttonStyle(.plain)

                // Tile 4: Purchase & TCO Ledger
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        store.activeTab = .lifecycle
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("📊")
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                                .background(AutoColor.purple.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                            Text(String(format: "残值 %.1f万", car.purchase.estimatedResale / 10000))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(AutoColor.purple)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(AutoColor.purple.opacity(0.16), in: Capsule())
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "¥%.2f", car.totalRunningCosts / 10000))
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                            Text("万")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 2)

                        Text("累计养车支出 (不含购车)")
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundStyle(.secondary)

                        HStack {
                            Text(String(format: "落地 ¥%.1f万", car.purchase.totalLanded / 10000))
                            Spacer()
                            Text("TCO ›")
                        }
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 2)
                    }
                    .foregroundStyle(.primary)
                    .liquidGlassCard(cornerRadius: 26)
                }
                .buttonStyle(.plain)
            }

            // 2.5 Iteration 08: Monthly Budget & Spend Radar Card
            monthlyBudgetRadarCard

            // 3. Recent Lifecycle Stream Preview
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("⏱️ 最近车务动态")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                            store.activeTab = .lifecycle
                        }
                    } label: {
                        Text("全周期 (\(car.timeline.count)) ›")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                let recentEvents = Array(car.timeline.prefix(3))
                VStack(spacing: 0) {
                    ForEach(Array(recentEvents.enumerated()), id: \.element.id) { idx, item in
                        TimelineNodeView(event: item, isLast: idx == recentEvents.count - 1)
                    }
                }
            }
            .liquidGlassCard(cornerRadius: 28)
        }
    }

    // MARK: - Iteration 08: Monthly Budget & Spend Radar Card
    private var monthlyBudgetRadarCard: some View {
        let ratio = car.currentMonthSpend / max(1, car.monthlyBudgetTarget)
        let pct = Int((ratio * 100).rounded())
        let stateColor: Color = ratio > 1.0 ? AutoColor.rose : (ratio >= 0.8 ? AutoColor.amber : AutoColor.emerald)
        let remaining = car.monthlyBudgetTarget - car.currentMonthSpend

        return VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text("💰 本月养车预算雷达")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Button {
                    store.compareSheetPresented = true
                } label: {
                    Text("⚖️ 双车PK")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AutoColor.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AutoColor.purple.opacity(0.15), in: Capsule())
                }
                Button {
                    store.cycleMonthlyBudgetTarget()
                } label: {
                    Text("预算 ¥\(Int(car.monthlyBudgetTarget).formatted()) ⟳")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AutoColor.cyan)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(AutoColor.cyan.opacity(0.15), in: Capsule())
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.13))
                    Capsule()
                        .fill(stateColor)
                        .frame(width: geo.size.width * CGFloat(min(1.0, max(0.05, ratio))))
                }
            }
            .frame(height: 8)

            HStack {
                Text("本月已支出 ¥\(Int(car.currentMonthSpend).formatted()) (\(pct)%)")
                    .fontWeight(.bold)
                Spacer()
                Text(remaining >= 0 ? "剩余可用 ¥\(Int(remaining).formatted())" : "已超支 ¥\(Int(abs(remaining)).formatted())")
                    .fontWeight(.bold)
                    .foregroundStyle(stateColor)
            }
            .font(.system(size: 11.5, design: .rounded))
            .monospacedDigit()
        }
        .liquidGlassCard(cornerRadius: 26)
    }
}
