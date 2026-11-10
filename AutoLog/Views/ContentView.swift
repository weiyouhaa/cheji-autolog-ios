import SwiftUI

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
            HStack(spacing: 8) {
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
