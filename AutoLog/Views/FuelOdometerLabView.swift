import SwiftUI

struct FuelOdometerLabView: View {
    @EnvironmentObject var store: VehicleStore

    var car: Vehicle { store.currentVehicle }

    var body: some View {
        VStack(spacing: 12) {
            // 1. Fuel / Energy Efficiency Summary + Trend Curve
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("⛽ \(car.isEV ? "补能与百公里电耗曲线" : "满箱油耗与油价监控")")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    StatusChip(text: car.energyType, color: AutoColor.amber)
                }

                // 3-Column Summary Cards
                HStack(spacing: 8) {
                    statBox(
                        title: "平均\(car.isEV ? "电耗" : "油耗")",
                        value: String(format: "%.2f", car.avgConsumption),
                        unit: car.consumptionUnit,
                        color: AutoColor.amber
                    )
                    statBox(
                        title: "每公里成本",
                        value: String(format: "¥%.2f", car.energyCostPerKm),
                        unit: "元 / 公里",
                        color: AutoColor.emerald
                    )
                    statBox(
                        title: "累计\(car.isEV ? "电费" : "油费")",
                        value: "¥\(Int(car.totalFuelSpend).formatted())",
                        unit: "共 \(max(1, car.fuelLogs.count * 8)) 次记录",
                        color: AutoColor.cyan
                    )
                }

                // Consumption Trend Chart Stage
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("近 \(min(5, max(1, car.fuelLogs.count))) 次加注实测波动 (\(car.consumptionUnit))")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("● 黄金右脚区间")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AutoColor.emerald)
                    }

                    ConsumptionCurveCanvas(logs: Array(car.fuelLogs.prefix(5).reversed()))
                        .frame(height: 105)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                )
            }
            .liquidGlassCard(cornerRadius: 28)

            // 1.5 Iteration 03: Driving Scenario Analytics & Trip Logbook
            tripScenarioAnalyticsCard

            // 2. Detailed Refueling / Charging Ledger
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🧾 每次\(car.isEV ? "充换电" : "加油")跳枪明细")
                        .font(.system(size: 14.5, weight: .bold))
                    Spacer()
                    Button {
                        store.openQuickLog(.fuel)
                    } label: {
                        Text("+ 记油耗")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(AutoColor.accentOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4.5)
                            .background(AutoColor.accentOrange.opacity(0.14), in: Capsule())
                    }
                }

                VStack(spacing: 9) {
                    ForEach(car.fuelLogs) { log in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("\(log.date) · \(log.station)")
                                    .font(.system(size: 13, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text(String(format: "-¥%.1f", log.cost))
                                    .font(.system(size: 13.5, weight: .heavy, design: .rounded))
                                    .monospacedDigit()
                            }

                            HStack {
                                Text("里程 \(log.odo.formatted()) km (+\(log.deltaKm)km)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "⚡ %.2f %@", log.consumption, car.consumptionUnit))
                                    .fontWeight(.bold)
                                    .foregroundStyle(AutoColor.amber)
                            }
                            .font(.system(size: 11.5))
                            .monospacedDigit()

                            HStack {
                                Text(String(format: "加注 %.1f %@ × ¥%.2f/%@", log.volume, car.isEV ? "kWh" : "L", log.price, car.isEV ? "度" : "L"))
                                Spacer()
                                Text(log.note)
                                    .lineLimit(1)
                            }
                            .font(.system(size: 10.5))
                            .foregroundStyle(.tertiary)
                            .monospacedDigit()
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

    private func statBox(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 16.5, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(unit)
                .font(.system(size: 9.5, weight: .medium))
                .foregroundStyle(.tertiary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(color.opacity(0.12))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(color.opacity(0.3), lineWidth: 1))
        )
    }

    // MARK: - Iteration 03: Driving Scenario Analytics & Trip Logbook Card
    private var tripScenarioAnalyticsCard: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text("🧭 路况能耗拆解与行程路书")
                    .font(.system(size: 14.5, weight: .bold))
                Spacer()
                Text("点击打卡行程")
                    .font(.system(size: 10.5, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            // 3 Quick Scenario Check-in Buttons
            HStack(spacing: 8) {
                scenarioPill(title: "🛣️ 高速巡航", value: car.isEV ? "15.4 kWh" : "6.4 L", color: AutoColor.emerald)
                scenarioPill(title: "🏙️ 市区通勤", value: car.isEV ? "13.1 kWh" : "9.2 L", color: AutoColor.amber)
                scenarioPill(title: "⛰️ 跑山露营", value: car.isEV ? "14.8 kWh" : "7.8 L", color: AutoColor.cyan)
            }

            VStack(spacing: 7) {
                ForEach(car.trips.prefix(3)) { trip in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(trip.date) · \(trip.title)")
                                .font(.system(size: 12.5, weight: .bold))
                                .lineLimit(1)
                            Text("\(trip.scenario) · 均速 \(trip.avgSpeedKmh) km/h")
                                .font(.system(size: 10.5))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("+\(trip.distanceKm) km")
                                .font(.system(size: 12.5, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                            Text(String(format: "%.1f %@", trip.consumption, car.consumptionUnit))
                                .font(.system(size: 10.5, weight: .bold))
                                .foregroundStyle(AutoColor.emerald)
                                .monospacedDigit()
                        }
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color.primary.opacity(0.045))
                            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                    )
                }
            }
        }
        .liquidGlassCard(cornerRadius: 28)
    }

    private func scenarioPill(title: String, value: String, color: Color) -> some View {
        Button {
            store.logQuickDrivingTrip(scenario: title)
        } label: {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                Text(value)
                    .font(.system(size: 13.5, weight: .heavy, design: .rounded))
                    .foregroundStyle(color)
                    .monospacedDigit()
                Text("+ 打卡该路况 ›")
                    .font(.system(size: 9.5, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(9)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color.opacity(0.11))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(color.opacity(0.28), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}

struct ConsumptionCurveCanvas: View {
    let logs: [FuelLog]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height - 20
            let values = logs.isEmpty ? [7.8, 8.1, 7.5, 8.0, 7.7] : logs.map(\.consumption)
            let minVal = (values.min() ?? 7.0) - 0.5
            let maxVal = (values.max() ?? 9.0) + 0.5
            let range = max(0.5, maxVal - minVal)

            ZStack(alignment: .topLeading) {
                Canvas { context, size in
                    // Dashed average reference line
                    var refLine = Path()
                    refLine.move(to: CGPoint(x: 10, y: h * 0.52))
                    refLine.addLine(to: CGPoint(x: w - 10, y: h * 0.52))
                    context.stroke(refLine, with: .color(AutoColor.emerald.opacity(0.45)), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    guard values.count > 1 else { return }
                    let stepX = (w - 36) / CGFloat(values.count - 1)
                    var points: [CGPoint] = []
                    for (i, v) in values.enumerated() {
                        let x = 18 + CGFloat(i) * stepX
                        let norm = (v - minVal) / range
                        let y = h - CGFloat(norm) * (h - 18) - 6
                        points.append(CGPoint(x: x, y: y))
                    }

                    // Area under curve
                    var areaPath = Path()
                    if let first = points.first, let last = points.last {
                        areaPath.move(to: first)
                        for p in points.dropFirst() {
                            areaPath.addLine(to: p)
                        }
                        areaPath.addLine(to: CGPoint(x: last.x, y: h))
                        areaPath.addLine(to: CGPoint(x: first.x, y: h))
                        areaPath.closeSubpath()
                        context.fill(
                            areaPath,
                            with: .linearGradient(
                                Gradient(colors: [AutoColor.accentOrange.opacity(0.4), AutoColor.accentOrange.opacity(0.0)]),
                                startPoint: CGPoint(x: 0, y: 8),
                                endPoint: CGPoint(x: 0, y: h)
                            )
                        )
                    }

                    // Line path
                    var linePath = Path()
                    if let first = points.first {
                        linePath.move(to: first)
                        for p in points.dropFirst() {
                            linePath.addLine(to: p)
                        }
                        context.stroke(linePath, with: .color(AutoColor.accentOrange), style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
                    }

                    // Data points
                    let minIdx = values.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
                    for (i, p) in points.enumerated() {
                        let isBest = (i == minIdx)
                        let r: CGFloat = isBest ? 4.8 : 4.0
                        let rect = CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)
                        context.fill(Path(ellipseIn: rect), with: .color(isBest ? AutoColor.emerald : Color(red: 0.09, green: 0.11, blue: 0.15)))
                        context.stroke(Path(ellipseIn: rect), with: .color(isBest ? .white : AutoColor.accentOrange), lineWidth: 2.2)
                    }
                }

                // Bottom Date Labels
                HStack {
                    ForEach(Array(logs.enumerated()), id: \.offset) { idx, log in
                        Text(idx == logs.count - 1 ? "最新(\(log.date))" : log.date)
                            .font(.system(size: 9.5, weight: idx == logs.count - 1 ? .bold : .medium))
                            .foregroundStyle(idx == logs.count - 1 ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .offset(y: h + 4)
            }
        }
    }
}
