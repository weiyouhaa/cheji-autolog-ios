import SwiftUI

struct LifecycleTCOView: View {
    @EnvironmentObject var store: VehicleStore
    @State private var showEarlyPayoffAlert = false
    @State private var selectedProjectionYear: Int = 3

    var car: Vehicle { store.currentVehicle }

    private let filterOptions: [(key: String, title: String)] = [
        ("all", "全部"),
        ("买车", "买车"),
        ("上路", "上路"),
        ("保养", "维保"),
        ("保险", "保险")
    ]

    var filteredTimeline: [TimelineEvent] {
        if store.lifecycleFilter == "all" {
            return car.timeline
        }
        return car.timeline.filter { $0.cat == store.lifecycleFilter }
    }

    var body: some View {
        VStack(spacing: 12) {
            // 1. Purchase & Acquisition Certificate Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🎖️ 提车与落户资产档案")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Button {
                        store.openQuickLog(.purchaseMod)
                    } label: {
                        Text("+ 记改装/车品")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                // 3-Column Metrics
                HStack(spacing: 8) {
                    metricBox(label: "落地总投入", value: String(format: "¥%.2f万", car.purchase.totalLanded / 10000), color: .primary)
                    metricBox(label: "裸车开票价", value: String(format: "¥%.2f万", car.purchase.nakedPrice / 10000), color: .primary)
                    metricBox(label: "当前估值", value: String(format: "¥%.2f万", car.purchase.estimatedResale / 10000), color: AutoColor.emerald)
                }

                VStack(spacing: 6) {
                    detailRow(title: "购置税 + 车管所上牌费", value: "¥\(Int(car.purchase.tax + car.purchase.regAndPlate).formatted())")
                    detailRow(title: "首年车险 + 精品改装 (车衣/太阳膜/车品)", value: "¥\(Int(car.purchase.firstInsurance + car.purchase.accessories).formatted())")
                    detailRow(title: "购置方式 / 交付中心", value: "\(car.purchase.loanStatus)")
                }
                .font(.system(size: 11.5))
            }
            .liquidGlassCard(cornerRadius: 28, tint: AutoColor.purple)

            // 1.5 Iteration 02: Auto Loan & Financing Calculator Card
            loanFinancingCard

            // 1.8 Iteration 04: 5-Year Depreciation Curve & Trade-In Advisor Card
            depreciationAdvisorCard

            // 2. Total Cost of Ownership (TCO) Breakdown
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("📊 拥车总成本结构 (TCO 透视)")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Text(String(format: "综合 ¥%.2f/km", car.comprehensiveCostPerKm))
                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                // Stacked Proportional Bar
                GeometryReader { geo in
                    let total = max(1, car.totalRunningCosts)
                    let wFuel = geo.size.width * CGFloat(car.totalFuelSpend / total)
                    let wIns  = geo.size.width * CGFloat(car.totalInsuranceSpend / total)
                    let wMaint = geo.size.width * CGFloat(car.totalMaintSpend / total)
                    let wOther = max(12, geo.size.width - wFuel - wIns - wMaint - 6)

                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 4).fill(AutoColor.amber).frame(width: max(12, wFuel))
                        RoundedRectangle(cornerRadius: 4).fill(AutoColor.emerald).frame(width: max(12, wIns))
                        RoundedRectangle(cornerRadius: 4).fill(AutoColor.cyan).frame(width: max(12, wMaint))
                        RoundedRectangle(cornerRadius: 4).fill(AutoColor.purple).frame(width: max(12, wOther))
                    }
                }
                .frame(height: 10)
                .clipShape(Capsule())

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                    tcoPill(dotColor: AutoColor.amber, title: car.isEV ? "充换电费" : "燃油费", amount: car.totalFuelSpend)
                    tcoPill(dotColor: AutoColor.emerald, title: "历年保险", amount: car.totalInsuranceSpend)
                    tcoPill(dotColor: AutoColor.cyan, title: "保养维修", amount: car.totalMaintSpend)
                    tcoPill(dotColor: AutoColor.purple, title: "停车/ETC/美容", amount: car.totalOtherSpend)
                }
            }
            .liquidGlassCard(cornerRadius: 28)

            // 3. Full Lifecycle Timeline
            VStack(alignment: .leading, spacing: 12) {
                Text("🧭 从买车到上路 · 全生命周期时间轴")
                    .font(.system(size: 14.5, weight: .bold))

                // Liquid Glass Segmented Filter
                HStack(spacing: 4) {
                    ForEach(filterOptions, id: \.key) { item in
                        let isSelected = store.lifecycleFilter == item.key
                        Button {
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                                store.lifecycleFilter = item.key
                            }
                        } label: {
                            Text(item.title)
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(isSelected ? Color.primary.opacity(0.14) : Color.clear)
                                )
                                .foregroundStyle(isSelected ? .primary : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(3.5)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.primary.opacity(0.06))
                        .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
                )

                VStack(spacing: 0) {
                    ForEach(Array(filteredTimeline.enumerated()), id: \.element.id) { idx, event in
                        TimelineNodeView(event: event, isLast: idx == filteredTimeline.count - 1)
                    }
                }
            }
            .liquidGlassCard(cornerRadius: 28)
        }
        .alert("🧮 车贷提前结清省息精算", isPresented: $showEarlyPayoffAlert) {
            Button("办理提前结清 (省息 ¥\(Int(car.purchase.loanPlan.estimatedInterestSavedOnEarlyPayoff)))") {
                store.settleLoanEarly()
            }
            Button("继续按月还供", role: .cancel) {}
        } message: {
            let plan = car.purchase.loanPlan
            Text("当前剩余 \(plan.remainingMonths) 期，待还本息 ¥\(Int(plan.remainingBalance).formatted())。\n若本月一次性提前结清（免违约金期），预计可节省后续利息约 ¥\(Int(plan.estimatedInterestSavedOnEarlyPayoff).formatted())。")
        }
    }

    // MARK: - Iteration 02: Auto Loan & Financing Card
    private var loanFinancingCard: some View {
        let plan = car.purchase.loanPlan
        let progress = Double(plan.paidMonths) / Double(max(1, plan.totalMonths))

        return VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text("🏦 购车金融与分期还款精算")
                    .font(.system(size: 14.5, weight: .bold))
                Spacer()
                StatusChip(
                    text: plan.remainingMonths == 0 ? "已结清解押" : "已还 \(plan.paidMonths)/\(plan.totalMonths) 期",
                    color: plan.remainingMonths == 0 ? AutoColor.emerald : AutoColor.cyan
                )
            }

            HStack(spacing: 8) {
                metricBox(label: "每期月供", value: "¥\(Int(plan.monthlyPayment).formatted())", color: AutoColor.cyan)
                metricBox(label: "剩余本息", value: "¥\(Int(plan.remainingBalance).formatted())", color: .primary)
                metricBox(label: "提前结清省息", value: "¥\(Int(plan.estimatedInterestSavedOnEarlyPayoff).formatted())", color: AutoColor.emerald)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.12))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [AutoColor.cyan, AutoColor.emerald],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(min(1.0, progress)))
                }
            }
            .frame(height: 7)

            HStack(spacing: 8) {
                Button {
                    store.recordLoanMonthlyPayment()
                } label: {
                    Text("💳 记一期月供扣款")
                        .font(.system(size: 11.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(AutoColor.cyan.opacity(0.16), in: Capsule())
                        .foregroundStyle(AutoColor.cyan)
                }
                .buttonStyle(.plain)

                Button {
                    showEarlyPayoffAlert = true
                } label: {
                    Text("🧮 提前还款省息试算")
                        .font(.system(size: 11.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(AutoColor.emerald.opacity(0.16), in: Capsule())
                        .foregroundStyle(AutoColor.emerald)
                }
                .buttonStyle(.plain)
            }
        }
        .liquidGlassCard(cornerRadius: 28)
    }

    // MARK: - Iteration 04: 5-Year Depreciation Curve & Trade-In Advisor Card
    private var depreciationAdvisorCard: some View {
        let projections = car.fiveYearResaleProjections
        let currentProj = projections.first(where: { $0.year == selectedProjectionYear }) ?? projections[2]

        return VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text("📉 5年残值预测与黄金换车顾问")
                    .font(.system(size: 14.5, weight: .bold))
                Spacer()
                StatusChip(text: "第3年最优换车拐点", color: AutoColor.emerald)
            }

            // 5-Year Bar & Selector Strip
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(projections) { item in
                    let isSelected = (item.year == selectedProjectionYear)
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                            selectedProjectionYear = item.year
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text("\(item.retentionPct)%")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(isSelected ? AutoColor.emerald : .secondary)

                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(
                                    isSelected
                                        ? LinearGradient(colors: [AutoColor.emerald, AutoColor.cyan], startPoint: .top, endPoint: .bottom)
                                        : LinearGradient(colors: [Color.primary.opacity(0.18), Color.primary.opacity(0.08)], startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: CGFloat(item.retentionPct) * 0.58)

                            Text("第\(item.year)年")
                                .font(.system(size: 11, weight: isSelected ? .heavy : .semibold))
                                .foregroundStyle(isSelected ? .primary : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(isSelected ? AutoColor.emerald.opacity(0.12) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(isSelected ? AutoColor.emerald.opacity(0.4) : Color.clear, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Selected Year Detail Banner
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(String(format: "第 %d 年预计残值：¥%.2f 万 (保值率 %d%%)", currentProj.year, currentProj.estimatedValue / 10000.0, currentProj.retentionPct))
                        .font(.system(size: 12.5, weight: .heavy, design: .rounded))
                    Spacer()
                    Text("当年折旧 -¥\(Int(currentProj.annualDrop).formatted())")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AutoColor.rose)
                }
                .monospacedDigit()

                Text(currentProj.advice)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.primary.opacity(0.045))
                    .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
            )
        }
        .liquidGlassCard(cornerRadius: 28)
    }

    private func metricBox(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 14.5, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.primary.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.14), lineWidth: 1))
        )
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .monospacedDigit()
        }
    }

    private func tcoPill(dotColor: Color, title: String, amount: Double) -> some View {
        HStack {
            HStack(spacing: 5) {
                Circle().fill(dotColor).frame(width: 7, height: 7)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            Spacer()
            Text("¥\(Int(amount).formatted())")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .monospacedDigit()
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.primary.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
        )
    }
}
