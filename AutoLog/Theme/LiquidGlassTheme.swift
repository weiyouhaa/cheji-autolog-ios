import SwiftUI

enum AutoColor {
    static let accentOrange = Color(red: 1.0, green: 0.369, blue: 0.169) // #FF5E2B
    static let emerald = Color(red: 0.204, green: 0.827, blue: 0.600)      // #34D399
    static let amber = Color(red: 0.984, green: 0.749, blue: 0.141)        // #FBBF24
    static let cyan = Color(red: 0.220, green: 0.741, blue: 0.973)         // #38BDF8
    static let purple = Color(red: 0.753, green: 0.518, blue: 0.988)       // #C084FC
    static let rose = Color(red: 0.984, green: 0.443, blue: 0.522)         // #FB7185

    static func fromName(_ name: String) -> Color {
        switch name {
        case "amber": return amber
        case "blue": return cyan
        case "emerald": return emerald
        case "rose": return rose
        case "purple": return purple
        default: return accentOrange
        }
    }
}

// MARK: - iOS 27 Spatial Ambient Mesh Background
struct SpatialMeshBackground: View {
    let isDark: Bool

    var body: some View {
        ZStack {
            (isDark ? Color(red: 0.027, green: 0.035, blue: 0.059) : Color(red: 0.933, green: 0.949, blue: 0.976))
                .ignoresSafeArea()

            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(AutoColor.accentOrange.opacity(isDark ? 0.24 : 0.18))
                        .frame(width: 280, height: 280)
                        .blur(radius: 65)
                        .offset(x: -geo.size.width * 0.28, y: -geo.size.height * 0.18)

                    Circle()
                        .fill(AutoColor.cyan.opacity(isDark ? 0.20 : 0.22))
                        .frame(width: 300, height: 300)
                        .blur(radius: 75)
                        .offset(x: geo.size.width * 0.34, y: geo.size.height * 0.08)

                    Circle()
                        .fill(AutoColor.purple.opacity(isDark ? 0.18 : 0.15))
                        .frame(width: 290, height: 290)
                        .blur(radius: 75)
                        .offset(x: -geo.size.width * 0.18, y: geo.size.height * 0.36)
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - iOS 27 Liquid Glass Card Modifier with Specular Rim Highlight
struct LiquidGlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 28
    var tintColor: Color? = nil

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    if let tintColor {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [tintColor.opacity(0.16), tintColor.opacity(0.03)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.42),
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.05),
                                Color.white.opacity(0.22)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.1
                    )
            )
            .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func liquidGlassCard(cornerRadius: CGFloat = 28, tint: Color? = nil) -> some View {
        modifier(LiquidGlassCardModifier(cornerRadius: cornerRadius, tintColor: tint))
    }
}

// MARK: - Specular Status Chip
struct StatusChip: View {
    let text: String
    let color: Color
    var showDot: Bool = false

    var body: some View {
        HStack(spacing: 5) {
            if showDot {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                    .shadow(color: color, radius: 3)
            }
            Text(text)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4.5)
        .background(
            Capsule(style: .continuous)
                .fill(color.opacity(0.18))
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(color.opacity(0.38), lineWidth: 1)
                )
        )
    }
}

// MARK: - Vector Car Silhouette View (Fuel Sedan vs EV Touring)
struct CarSilhouetteView: View {
    let isEV: Bool

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let scaleX = w / 260.0
            let scaleY = h / 78.0

            func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: x * scaleX, y: y * scaleY)
            }

            // Ground shadow
            let shadowRect = CGRect(x: 22 * scaleX, y: 61 * scaleY, width: 216 * scaleX, height: 11 * scaleY)
            context.fill(Path(ellipseIn: shadowRect), with: .color(Color.black.opacity(0.45)))

            // Body contour
            var bodyPath = Path()
            if !isEV {
                bodyPath.move(to: pt(22, 50))
                bodyPath.addCurve(to: pt(56, 34), control1: pt(24, 41), control2: pt(34, 36))
                bodyPath.addLine(to: pt(88, 18))
                bodyPath.addCurve(to: pt(174, 20), control1: pt(102, 14), control2: pt(152, 14))
                bodyPath.addLine(to: pt(204, 33))
                bodyPath.addCurve(to: pt(238, 49), control1: pt(224, 35), control2: pt(236, 40))
                bodyPath.addLine(to: pt(236, 57))
                bodyPath.addCurve(to: pt(214, 61), control1: pt(234, 60), control2: pt(224, 61))
                bodyPath.addLine(to: pt(44, 61))
                bodyPath.addCurve(to: pt(22, 50), control1: pt(30, 61), control2: pt(22, 58))
                bodyPath.closeSubpath()

                context.fill(
                    bodyPath,
                    with: .linearGradient(
                        Gradient(colors: [Color(white: 0.62), Color(white: 0.92), Color(white: 0.35)]),
                        startPoint: pt(20, 15),
                        endPoint: pt(240, 65)
                    )
                )
            } else {
                // Roof box bar for Touring EV
                let roofRect = CGRect(x: 108 * scaleX, y: 10 * scaleY, width: 64 * scaleX, height: 5 * scaleY)
                context.fill(Path(roundedRect: roofRect, cornerRadius: 2.5), with: .color(Color(white: 0.25)))

                bodyPath.move(to: pt(22, 50))
                bodyPath.addCurve(to: pt(60, 33), control1: pt(25, 40), control2: pt(38, 35))
                bodyPath.addLine(to: pt(94, 17))
                bodyPath.addCurve(to: pt(212, 22), control1: pt(116, 14), control2: pt(182, 14))
                bodyPath.addLine(to: pt(232, 36))
                bodyPath.addCurve(to: pt(236, 56), control1: pt(237, 41), control2: pt(238, 48))
                bodyPath.addCurve(to: pt(212, 61), control1: pt(234, 60), control2: pt(222, 61))
                bodyPath.addLine(to: pt(42, 61))
                bodyPath.addCurve(to: pt(22, 50), control1: pt(28, 61), control2: pt(22, 57))
                bodyPath.closeSubpath()

                context.fill(
                    bodyPath,
                    with: .linearGradient(
                        Gradient(colors: [Color(red: 0.99, green: 0.88, blue: 0.28), Color(red: 0.98, green: 0.80, blue: 0.08), Color(red: 0.79, green: 0.54, blue: 0.02)]),
                        startPoint: pt(20, 15),
                        endPoint: pt(240, 65)
                    )
                )
            }
            context.stroke(bodyPath, with: .color(Color.white.opacity(0.45)), lineWidth: 1.2)

            // Cabin Window
            var winPath = Path()
            winPath.move(to: pt(66, 33))
            winPath.addLine(to: pt(93, 20))
            winPath.addCurve(to: pt(isEV ? 204 : 168, 22), control1: pt(110, 16), control2: pt(isEV ? 178 : 148, 16))
            winPath.addLine(to: pt(isEV ? 218 : 191, 33))
            winPath.closeSubpath()
            context.fill(winPath, with: .color(Color(red: 0.08, green: 0.11, blue: 0.18)))
            context.stroke(winPath, with: .color(Color.white.opacity(0.25)), lineWidth: 1)

            // Headlight & Taillight
            var headLight = Path()
            headLight.move(to: pt(24, 45))
            headLight.addLine(to: pt(38, 43))
            headLight.addLine(to: pt(35, 48))
            headLight.addLine(to: pt(23, 49))
            headLight.closeSubpath()
            context.fill(headLight, with: .color(AutoColor.cyan))

            var tailLight = Path()
            tailLight.move(to: pt(223, 41))
            tailLight.addLine(to: pt(237, 43))
            tailLight.addLine(to: pt(236, 48))
            tailLight.addLine(to: pt(221, 46))
            tailLight.closeSubpath()
            context.fill(tailLight, with: .color(AutoColor.accentOrange))

            // Wheels
            for wx in [64.0, 194.0] {
                let rOuter = 15.0 * min(scaleX, scaleY)
                let rInner = 9.0 * min(scaleX, scaleY)
                let rHub = 3.5 * min(scaleX, scaleY)
                let center = pt(wx, 57)

                let outerRect = CGRect(x: center.x - rOuter, y: center.y - rOuter, width: rOuter * 2, height: rOuter * 2)
                context.fill(Path(ellipseIn: outerRect), with: .color(Color(red: 0.06, green: 0.09, blue: 0.15)))
                context.stroke(Path(ellipseIn: outerRect), with: .color(Color(white: 0.3)), lineWidth: 2.5)

                let innerRect = CGRect(x: center.x - rInner, y: center.y - rInner, width: rInner * 2, height: rInner * 2)
                context.stroke(Path(ellipseIn: innerRect), with: .color(Color(white: 0.72)), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))

                let hubRect = CGRect(x: center.x - rHub, y: center.y - rHub, width: rHub * 2, height: rHub * 2)
                context.fill(Path(ellipseIn: hubRect), with: .color(isEV ? AutoColor.emerald : AutoColor.accentOrange))
            }
        }
    }
}

// MARK: - Reusable Timeline Node View (Iteration 05 Interactive CRUD)
struct TimelineNodeView: View {
    @EnvironmentObject var store: VehicleStore
    let event: TimelineEvent
    let isLast: Bool
    @State private var showInspector = false

    var dotColor: Color {
        AutoColor.fromName(event.color)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left timeline line + glowing dot
            VStack(spacing: 0) {
                Circle()
                    .fill(dotColor)
                    .frame(width: 10, height: 10)
                    .shadow(color: dotColor.opacity(0.8), radius: 4)
                    .padding(.top, 6)

                if !isLast {
                    Rectangle()
                        .fill(Color.primary.opacity(0.14))
                        .frame(width: 1.5)
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 2)
                }
            }
            .frame(width: 12)

            // Right card (Tappable to Inspect / Edit / Delete)
            Button {
                showInspector = true
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(event.title)
                            .font(.system(size: 13.5, weight: .bold))
                            .lineLimit(1)
                        Spacer()
                        Text(event.cost)
                            .font(.system(size: 13.5, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                    }

                    HStack(spacing: 6) {
                        Text("📅 \(event.date)")
                        Text("·")
                        Text("🛣️ \(event.odo)")
                        Text("·")
                        Text("#\(event.cat)")
                            .fontWeight(.bold)
                            .foregroundStyle(dotColor)
                        Spacer()
                        Text("编辑 ›")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.tertiary)
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(event.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(Color.primary.opacity(0.07))
                                    )
                            }
                        }
                    }
                }
                .padding(11)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.primary.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.14), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
            .padding(.bottom, isLast ? 2 : 10)
        }
        .sheet(isPresented: $showInspector) {
            TimelineEventInspectorSheet(event: event)
                .environmentObject(store)
                .presentationDetents([.height(350)])
                .presentationCornerRadius(32)
        }
    }
}

struct TimelineEventInspectorSheet: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss
    let event: TimelineEvent

    @State private var title: String = ""
    @State private var cost: String = ""
    @State private var odo: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                VStack(alignment: .leading, spacing: 12) {
                    VStack(spacing: 10) {
                        HStack {
                            Text("项目名称")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 68, alignment: .leading)
                            TextField("", text: $title)
                                .font(.system(size: 13.5, weight: .bold))
                        }
                        Divider()
                        HStack {
                            Text("记账金额")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 68, alignment: .leading)
                            TextField("", text: $cost)
                                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        }
                        Divider()
                        HStack {
                            Text("记录里程")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 68, alignment: .leading)
                            TextField("", text: $odo)
                                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        }
                    }
                    .liquidGlassCard(cornerRadius: 24)

                    HStack(spacing: 10) {
                        Button(role: .destructive) {
                            store.deleteTimelineEvent(id: event.id)
                            dismiss()
                        } label: {
                            Text("🗑️ 删除此记录")
                                .font(.system(size: 13.5, weight: .bold))
                                .foregroundStyle(AutoColor.rose)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AutoColor.rose.opacity(0.16), in: Capsule())
                        }
                        .buttonStyle(.plain)

                        Button {
                            store.updateTimelineEvent(id: event.id, title: title, cost: cost, odo: odo)
                            dismiss()
                        } label: {
                            Text("💾 保存修改")
                                .font(.system(size: 13.5, weight: .heavy))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AutoColor.accentOrange, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("📝 账单记录详情与编辑")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
            .onAppear {
                title = event.title
                cost = event.cost
                odo = event.odo
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }
}
