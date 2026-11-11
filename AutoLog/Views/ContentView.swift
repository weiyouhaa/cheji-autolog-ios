import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var store: VehicleStore

    var car: Vehicle { store.currentVehicle }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. iOS 27 Spatial Ambient Mesh Background
            SpatialMeshBackground(isDark: store.isDarkMode)

            // 2. Main Scrollable Viewport
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    topLiquidNavigationBar

                    Group {
                        switch store.activeTab {
                        case .cockpit:
                            CockpitHomeView()
                        case .lifecycle:
                            LifecycleTCOView()
                        case .fuel:
                            FuelOdometerLabView()
                        case .maintenance, .insurance:
                            MaintenanceAndInsuranceView()
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
                .padding(.horizontal, 15)
                .padding(.top, 6)
                .padding(.bottom, 108)
            }

            // 3. iOS 27 Floating Liquid Glass Capsule Tab Bar
            floatingLiquidTabBar
                .padding(.horizontal, 14)
                .padding(.bottom, 8)

            // 4. Floating Toast Notification
            if let toast = store.toastMessage {
                VStack {
                    Text(toast)
                        .font(.system(size: 12.5, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(
                            Capsule(style: .continuous)
                                .fill(AutoColor.emerald.opacity(0.92))
                                .overlay(Capsule().strokeBorder(Color.white.opacity(0.45), lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
                        )
                        .padding(.top, 8)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
        .sheet(isPresented: $store.quickLogPresented) {
            QuickLogSheetView()
                .environmentObject(store)
                .presentationDetents([.large, .fraction(0.84)])
                .presentationCornerRadius(36)
        }
        .sheet(isPresented: $store.addVehiclePresented) {
            AddVehicleSheetView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationCornerRadius(36)
        }
        .sheet(isPresented: $store.compareSheetPresented) {
            GarageCompareSheetView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationCornerRadius(36)
        }
        .sheet(isPresented: $store.exportSheetPresented) {
            DataExportSheetView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationCornerRadius(36)
        }
        .sheet(isPresented: $store.widgetGalleryPresented) {
            WidgetGallerySheetView()
                .environmentObject(store)
                .presentationDetents([.large])
                .presentationCornerRadius(36)
        }
    }

    // MARK: - Top Liquid Glass Header Bar
    private var topLiquidNavigationBar: some View {
        HStack {
            // Vehicle Switcher Menu Capsule
            Menu {
                Section("我的车库 (\(store.vehicles.count) 辆)") {
                    ForEach(store.vehicles) { v in
                        Button {
                            store.switchVehicle(v.id)
                        } label: {
                            Label(
                                "\(v.plate) · \(v.name)",
                                systemImage: v.id == store.currentVehicleId ? "checkmark.circle.fill" : (v.isEV ? "bolt.car.fill" : "car.fill")
                            )
                        }
                    }
                }
                Section("车库管理") {
                    Button {
                        store.compareSheetPresented = true
                    } label: {
                        Label("双车横向对比 PK 实验室", systemImage: "chart.bar.xaxis")
                    }

                    Button {
                        store.widgetGalleryPresented = true
                    } label: {
                        Label("iOS 27 桌面组件与灵动岛预览", systemImage: "rectangle.3.group.fill")
                    }

                    Button {
                        store.exportSheetPresented = true
                    } label: {
                        Label("导出账单 & 二手卖车履历...", systemImage: "square.and.arrow.up")
                    }

                    Button {
                        store.addVehiclePresented = true
                    } label: {
                        Label("添加新车入库...", systemImage: "plus.circle.fill")
                    }

                    Button(role: .destructive) {
                        store.resetSampleData()
                    } label: {
                        Label("恢复演示初始数据", systemImage: "arrow.counterclockwise")
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(car.plate)
                        .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3.5)
                        .background(
                            Capsule(style: .continuous)
                                .fill(
                                    car.isEV
                                        ? LinearGradient(colors: [AutoColor.emerald, Color(red: 0.02, green: 0.58, blue: 0.41)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        : LinearGradient(colors: [Color(red: 0.15, green: 0.39, blue: 0.92), Color(red: 0.11, green: 0.31, blue: 0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        )

                    Text(car.name)
                        .font(.system(size: 13.5, weight: .bold))
                        .foregroundStyle(.primary)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 7)
                .padding(.trailing, 13)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule(style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.45), Color.white.opacity(0.14)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 4)
                )
            }

            Spacer()

            // Right Orb Buttons
            HStack(spacing: 7) {
                // Iteration 18: iOS 27 Widget & Dynamic Island Gallery Orb
                Button {
                    store.widgetGalleryPresented = true
                } label: {
                    Image(systemName: "rectangle.3.group.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AutoColor.cyan)
                        .frame(width: 35, height: 35)
                        .background(orbBackground)
                }
                .buttonStyle(.plain)

                // Theme Switcher Orb
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        store.isDarkMode.toggle()
                    }
                    store.showToast(store.isDarkMode ? "🌙 已切换至曜石液态玻璃 (Dark)" : "☀️ 已切换至冰晶液态玻璃 (Light)")
                } label: {
                    Image(systemName: store.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(store.isDarkMode ? AutoColor.purple : AutoColor.amber)
                        .frame(width: 36, height: 36)
                        .background(orbBackground)
                }
                .buttonStyle(.plain)

                // OCR Quick Scan Orb
                Button {
                    store.openQuickLog(.fuel)
                    store.showToast("📷 支持拍摄加油小票、维保工单与保单识别")
                } label: {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                        .background(orbBackground)
                }
                .buttonStyle(.plain)

                // Smart Alert Orb
                Button {
                    store.showToast("🔔 提醒：\(car.nextAlert)")
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(orbBackground)

                        Circle()
                            .fill(AutoColor.accentOrange)
                            .frame(width: 7, height: 7)
                            .offset(x: -7, y: 7)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var orbBackground: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .overlay(
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.45), Color.white.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.1
                    )
            )
            .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    // MARK: - iOS 27 Floating Liquid Glass Capsule Tab Bar
    private var floatingLiquidTabBar: some View {
        HStack(spacing: 4) {
            tabBarItem(tab: .cockpit, icon: "square.grid.2x2.fill", title: "座舱")
            tabBarItem(tab: .lifecycle, icon: "clock.arrow.circlepath", title: "全周期")

            // Center Specular Liquid Orb '+' Button
            Button {
                store.openQuickLog()
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.58, blue: 0.41),
                                    AutoColor.accentOrange,
                                    Color(red: 0.85, green: 0.20, blue: 0.02)
                                ],
                                center: UnitPoint(x: 0.32, y: 0.24),
                                startRadius: 2,
                                endRadius: 28
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white.opacity(0.55), lineWidth: 1.2)
                        )
                        .shadow(color: AutoColor.accentOrange.opacity(0.55), radius: 12, x: 0, y: 6)

                    Image(systemName: "plus")
                        .font(.system(size: 21, weight: .heavy))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 6)

            tabBarItem(tab: .fuel, icon: "fuelpump.fill", title: "能耗")
            tabBarItem(tab: .maintenance, icon: "wrench.and.screwdriver.fill", title: "维保车险", isActiveOverride: store.activeTab == .maintenance || store.activeTab == .insurance)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.14),
                                    Color.white.opacity(0.24)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                )
                .shadow(color: Color.black.opacity(0.42), radius: 22, x: 0, y: 12)
        )
    }

    private func tabBarItem(tab: AppTab, icon: String, title: String, isActiveOverride: Bool? = nil) -> some View {
        let isSelected = isActiveOverride ?? (store.activeTab == tab)
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                store.activeTab = tab
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                Text(title)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(isSelected ? (store.isDarkMode ? .white : AutoColor.accentOrange) : .secondary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.primary.opacity(0.13) : Color.clear)
                    .overlay(
                        Capsule(style: .continuous)
                            .strokeBorder(isSelected ? Color.white.opacity(0.28) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Iteration 10: Multi-Car Side-by-Side Benchmark Sheet
struct GarageCompareSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss

    var leftCar: Vehicle {
        store.vehicles.first ?? SampleVehicles.bmw330
    }

    var rightCar: Vehicle {
        store.vehicles.count > 1 ? store.vehicles[1] : SampleVehicles.nioEt5t
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Top Dual Vehicle Header
                        HStack(spacing: 10) {
                            carHeaderCard(car: leftCar, accent: AutoColor.accentOrange)
                            Text("VS")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundStyle(.secondary)
                            carHeaderCard(car: rightCar, accent: AutoColor.emerald)
                        }

                        // 6-Dimension Comparison Rows
                        VStack(spacing: 12) {
                            compareRow(
                                title: "⚡ 每公里能源费 (越低越省)",
                                leftVal: String(format: "¥%.2f/km", leftCar.energyCostPerKm),
                                rightVal: String(format: "¥%.2f/km", rightCar.energyCostPerKm),
                                leftWin: leftCar.energyCostPerKm < rightCar.energyCostPerKm
                            )
                            Divider()
                            compareRow(
                                title: "📊 单公里全周期 TCO (含折旧)",
                                leftVal: String(format: "¥%.2f/km", leftCar.comprehensiveCostPerKm),
                                rightVal: String(format: "¥%.2f/km", rightCar.comprehensiveCostPerKm),
                                leftWin: leftCar.comprehensiveCostPerKm < rightCar.comprehensiveCostPerKm
                            )
                            Divider()
                            compareRow(
                                title: "📅 日均拥车持有成本",
                                leftVal: String(format: "¥%.1f/天", leftCar.dailyHoldingCost),
                                rightVal: String(format: "¥%.1f/天", rightCar.dailyHoldingCost),
                                leftWin: leftCar.dailyHoldingCost < rightCar.dailyHoldingCost
                            )
                            Divider()
                            compareRow(
                                title: "🛡️ 年度车险保费支出",
                                leftVal: "¥\(Int(leftCar.insurance.totalPremium).formatted())",
                                rightVal: "¥\(Int(rightCar.insurance.totalPremium).formatted())",
                                leftWin: leftCar.insurance.totalPremium < rightCar.insurance.totalPremium
                            )
                            Divider()
                            compareRow(
                                title: "🎖️ 购车落地总投入",
                                leftVal: String(format: "¥%.2f万", leftCar.purchase.totalLanded / 10000),
                                rightVal: String(format: "¥%.2f万", rightCar.purchase.totalLanded / 10000),
                                leftWin: leftCar.purchase.totalLanded < rightCar.purchase.totalLanded
                            )
                            Divider()
                            compareRow(
                                title: "💚 综合车况健康评分",
                                leftVal: "\(leftCar.healthScore) 分",
                                rightVal: "\(rightCar.healthScore) 分",
                                leftWin: leftCar.healthScore >= rightCar.healthScore
                            )
                        }
                        .liquidGlassCard(cornerRadius: 28)

                        // Smart Conclusion Banner
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💡 车库油电双车精算结论")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(AutoColor.cyan)
                            Text("• 市区高频代步优先开「\(rightCar.name)」，每跑 10,000 km 仅需能源费约 ¥\(Int(rightCar.energyCostPerKm * 10000).formatted())，比燃油车立省 ¥\(Int(max(0, leftCar.energyCostPerKm - rightCar.energyCostPerKm) * 10000).formatted())；\n• 长途跨省无补能焦虑场景优选「\(leftCar.name)」，高速巡航油耗低至 6.4L/百公里。")
                                .font(.system(size: 11.5))
                                .foregroundStyle(.secondary)
                        }
                        .liquidGlassCard(cornerRadius: 24, tint: AutoColor.cyan)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("⚖️ 车库双车横向 PK 实验室")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }

    private func carHeaderCard(car: Vehicle, accent: Color) -> some View {
        VStack(spacing: 4) {
            Text(car.plate)
                .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(accent, in: Capsule())
            Text(car.name)
                .font(.system(size: 13.5, weight: .heavy))
                .lineLimit(1)
            Text("\(car.odometer.formatted()) km")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .liquidGlassCard(cornerRadius: 22, tint: accent)
    }

    private func compareRow(title: String, leftVal: String, rightVal: String, leftWin: Bool) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
            HStack {
                Text(leftVal)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(leftWin ? AutoColor.emerald : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(rightVal)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(!leftWin ? AutoColor.emerald : .primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .monospacedDigit()
        }
    }
}

// MARK: - Iteration 17: CSV/JSON Export & Second-Hand Resale Resume Sheet
struct DataExportSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFormat: Int = 0 // 0: 卖车履历 | 1: CSV | 2: JSON

    private var previewContent: String {
        switch selectedFormat {
        case 0: return store.generateResaleResumeText()
        case 1: return store.generateCSVExportText()
        default: return store.generateJSONBackupText()
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("将多年真实记账沉淀转化为「个人一手精品车背书文案」，或导出为电子表格/JSON 归档备份。")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    // 3-Mode Liquid Glass Switcher
                    HStack(spacing: 6) {
                        modeButton(idx: 0, title: "🎖️ 卖车精品履历")
                        modeButton(idx: 1, title: "📊 CSV 表格账单")
                        modeButton(idx: 2, title: "📦 JSON 全量包")
                    }
                    .padding(4)
                    .background(Color.primary.opacity(0.06), in: Capsule())

                    // Code / Document Preview Window
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(selectedFormat == 0 ? "闲鱼 / 懂车帝 / 车友群挂牌文案预览" : (selectedFormat == 1 ? "Excel / Numbers 兼容 CSV 预览" : "AutoLog 结构化 JSON 档案预览"))
                                .font(.system(size: 11.5, weight: .bold))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(previewContent.count) 字符")
                                .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.tertiary)
                        }

                        ScrollView(.vertical, showsIndicators: true) {
                            Text(previewContent)
                                .font(.system(size: 11.5, weight: .medium, design: selectedFormat == 0 ? .rounded : .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        .frame(height: 310)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.primary.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                    }
                    .liquidGlassCard(cornerRadius: 26, tint: AutoColor.accentOrange)

                    HStack(spacing: 10) {
                        Button {
                            UIPasteboard.general.string = previewContent
                            store.showToast("📋 已复制全文至剪贴板，可直接粘贴发布！")
                            dismiss()
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "doc.on.doc.fill")
                                Text("一键复制全文")
                            }
                            .font(.system(size: 13.5, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(AutoColor.accentOrange, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }

                        ShareLink(item: previewContent) {
                            HStack(spacing: 5) {
                                Image(systemName: "square.and.arrow.up")
                                Text("系统分享/存文件")
                            }
                            .font(.system(size: 13.5, weight: .bold))
                            .foregroundStyle(AutoColor.cyan)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(AutoColor.cyan.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("📤 导出备份与卖车履历")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }

    private func modeButton(idx: Int, title: String) -> some View {
        let active = (selectedFormat == idx)
        return Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                selectedFormat = idx
            }
        } label: {
            Text(title)
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(active ? .white : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(active ? AutoColor.accentOrange : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Iteration 18: iOS 27 Desktop Widgets & Dynamic Island Live Activity Gallery
struct WidgetGallerySheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss
    @State private var islandScene: Int = 0 // 0: 驻车寻车计费 | 1: 极速补能续航

    var car: Vehicle { store.currentVehicle }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("实时同步「\(car.name)」当前里程、停放车位、百公里能耗与保养提醒，1:1 预览 iOS 27 灵动岛与桌面液态小组件。")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    // 1. Dynamic Island Live Activity Preview
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("🏝️ 灵动岛实时活动 (Live Activity)")
                                .font(.system(size: 13.5, weight: .bold))
                            Spacer()
                            HStack(spacing: 4) {
                                islandPill(idx: 0, title: "🅿️ 驻车计费")
                                islandPill(idx: 1, title: car.isEV ? "⚡ 闪充监控" : "⛽ 续航导航")
                            }
                        }

                        // Pitch-black Dynamic Island Expanded Capsule
                        VStack(spacing: 12) {
                            HStack {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(islandScene == 0 ? AutoColor.cyan : AutoColor.emerald)
                                        .frame(width: 8, height: 8)
                                    Text(car.plate)
                                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                                        .foregroundStyle(.white)
                                    Text("· 车记 AutoLog")
                                        .font(.system(size: 10.5, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                Spacer()
                                Text(islandScene == 0 ? "LIVE 驻车中" : "LIVE 补能中")
                                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(islandScene == 0 ? AutoColor.cyan : AutoColor.emerald)
                            }

                            if islandScene == 0 {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("\(car.parkingSession.floor) · \(car.parkingSession.zoneSpot)")
                                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                                            .foregroundStyle(.white)
                                        Text(car.parkingSession.lotName)
                                            .font(.system(size: 11))
                                            .foregroundStyle(.white.opacity(0.65))
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 3) {
                                        Text("¥\(Int(car.parkingSession.estimatedFee))")
                                            .font(.system(size: 21, weight: .heavy, design: .rounded))
                                            .foregroundStyle(AutoColor.amber)
                                        Text("已停 \(car.parkingSession.formattedDuration)")
                                            .font(.system(size: 10.5, weight: .semibold))
                                            .foregroundStyle(.white.opacity(0.65))
                                    }
                                }
                            } else {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(car.isEV ? "⚡ 500kW 超充 · SoC 84%" : "⛽ 满箱可用续航 635 km")
                                            .font(.system(size: 15.5, weight: .heavy, design: .rounded))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text(car.isEV ? "剩 9 分钟满电" : "实测 \(String(format: "%.2f", car.avgConsumption))L")
                                            .font(.system(size: 11.5, weight: .bold))
                                            .foregroundStyle(AutoColor.emerald)
                                    }
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule().fill(Color.white.opacity(0.16))
                                            Capsule()
                                                .fill(LinearGradient(colors: [AutoColor.emerald, AutoColor.cyan], startPoint: .leading, endPoint: .trailing))
                                                .frame(width: geo.size.width * 0.84)
                                        }
                                    }
                                    .frame(height: 7)
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.22), lineWidth: 1.1)
                                )
                                .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 8)
                        )
                    }

                    // 2. Small 2x2 Home Widget + Lock Screen Circular Widget
                    Text("🖼️ iOS 27 桌面与锁屏液态玻璃组件")
                        .font(.system(size: 13.5, weight: .bold))

                    HStack(spacing: 12) {
                        // Small 2x2 Widget
                        VStack(alignment: .leading, spacing: 7) {
                            HStack {
                                Text(car.plate)
                                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 2.5)
                                    .background(AutoColor.accentOrange, in: Capsule())
                                Spacer()
                                Text("\(car.healthScore)分")
                                    .font(.system(size: 10.5, weight: .bold))
                                    .foregroundStyle(AutoColor.emerald)
                            }
                            Spacer(minLength: 2)
                            Text("\(car.odometer.formatted())")
                                .font(.system(size: 20, weight: .heavy, design: .monospaced))
                            Text("总里程 km · 日均 \(String(format: "%.0f", car.dailyKm))")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.secondary)
                            Text("能耗 \(String(format: "%.2f", car.avgConsumption)) \(car.consumptionUnit)")
                                .font(.system(size: 10.5, weight: .bold))
                                .foregroundStyle(AutoColor.cyan)
                        }
                        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
                        .liquidGlassCard(cornerRadius: 26, tint: AutoColor.accentOrange)

                        // Lock Screen Accessory Widget Card
                        VStack(spacing: 8) {
                            Text("锁屏实时圆环")
                                .font(.system(size: 10.5, weight: .semibold))
                                .foregroundStyle(.secondary)
                            ZStack {
                                Circle()
                                    .stroke(Color.primary.opacity(0.14), lineWidth: 7)
                                    .frame(width: 68, height: 68)
                                Circle()
                                    .trim(from: 0, to: CGFloat(car.healthScore) / 100.0)
                                    .stroke(AutoColor.emerald, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 68, height: 68)
                                VStack(spacing: 0) {
                                    Text("\(car.healthScore)")
                                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                                    Text("健康度")
                                        .font(.system(size: 8.5, weight: .bold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Text("保单剩 \(car.insurance.daysRemaining) 天")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(AutoColor.emerald)
                        }
                        .frame(width: 138, height: 132)
                        .liquidGlassCard(cornerRadius: 26, tint: AutoColor.emerald)
                    }

                    // 3. Medium 4x2 Cockpit Desktop Widget with Deep-Link Actions
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(car.name)
                                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                                Text("🔔 \(car.nextAlert)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            CarSilhouetteView(isEV: car.isEV)
                                .frame(width: 105, height: 34)
                        }

                        HStack(spacing: 8) {
                            Button {
                                dismiss()
                                store.openQuickLog(.fuel)
                            } label: {
                                Label(car.isEV ? "快记充换电" : "快记加油", systemImage: "bolt.fill")
                                    .font(.system(size: 11.5, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(AutoColor.accentOrange, in: Capsule())
                            }

                            Button {
                                dismiss()
                                store.activeTab = .cockpit
                                store.showToast("🅿️ 已定位至首页寻车记忆牌：\(car.parkingSession.floor) \(car.parkingSession.zoneSpot)")
                            } label: {
                                Label("\(car.parkingSession.floor) 寻车牌", systemImage: "parkingsign.circle.fill")
                                    .font(.system(size: 11.5, weight: .bold))
                                    .foregroundStyle(AutoColor.cyan)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(AutoColor.cyan.opacity(0.16), in: Capsule())
                            }
                        }
                    }
                    .liquidGlassCard(cornerRadius: 28, tint: AutoColor.cyan)
                }
                .padding(16)
            }
            .navigationTitle("✨ iOS 27 组件与灵动岛")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }

    private func islandPill(idx: Int, title: String) -> some View {
        let active = (islandScene == idx)
        return Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                islandScene = idx
            }
        } label: {
            Text(title)
                .font(.system(size: 10.5, weight: .bold))
                .foregroundStyle(active ? .white : .secondary)
                .padding(.horizontal, 9)
                .padding(.vertical, 4.5)
                .background(Capsule().fill(active ? AutoColor.cyan : Color.primary.opacity(0.08)))
        }
        .buttonStyle(.plain)
    }
}
