import SwiftUI

struct AddVehicleSheetView: View {
    @EnvironmentObject var store: VehicleStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = "Porsche Macan S"
    @State private var plate: String = "沪B·911GT"
    @State private var isEV: Bool = false
    @State private var nakedPrice: String = "568000"
    @State private var tax: String = "50265"
    @State private var firstIns: String = "12800"
    @State private var initialOdo: String = "35"
    @State private var colorName: String = "冰莓粉 / 波尔多红内"
    @State private var vin: String = "WP1AA295XRLB89110"

    var body: some View {
        NavigationStack {
            ZStack {
                SpatialMeshBackground(isDark: store.isDarkMode)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Energy Type Picker
                        HStack(spacing: 8) {
                            Button {
                                isEV = false
                                tax = "50265"
                            } label: {
                                Text("⛽ 燃油 / 混动车型")
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(!isEV ? AutoColor.accentOrange.opacity(0.22) : Color.primary.opacity(0.06))
                                            .overlay(Capsule().strokeBorder(!isEV ? AutoColor.accentOrange : Color.white.opacity(0.15), lineWidth: 1))
                                    )
                                    .foregroundStyle(!isEV ? AutoColor.accentOrange : .secondary)
                            }
                            .buttonStyle(.plain)

                            Button {
                                isEV = true
                                tax = "0"
                            } label: {
                                Text("⚡ 纯电新能源 (绿牌)")
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(isEV ? AutoColor.emerald.opacity(0.22) : Color.primary.opacity(0.06))
                                            .overlay(Capsule().strokeBorder(isEV ? AutoColor.emerald : Color.white.opacity(0.15), lineWidth: 1))
                                    )
                                    .foregroundStyle(isEV ? AutoColor.emerald : .secondary)
                            }
                            .buttonStyle(.plain)
                        }

                        VStack(spacing: 12) {
                            HStack(spacing: 10) {
                                field("品牌与车型名称", text: $name)
                                field("车牌号码", text: $plate)
                            }
                            HStack(spacing: 10) {
                                field("裸车开票价 (¥)", text: $nakedPrice, keyboard: .numberPad)
                                field("购置税 (¥)", text: $tax, keyboard: .numberPad)
                            }
                            HStack(spacing: 10) {
                                field("首年保险费 (¥)", text: $firstIns, keyboard: .numberPad)
                                field("当前表显里程 (km)", text: $initialOdo, keyboard: .numberPad)
                            }
                            HStack(spacing: 10) {
                                field("外观与内饰配色", text: $colorName)
                                field("车架号 VIN", text: $vin)
                            }
                        }
                        .liquidGlassCard(cornerRadius: 26)

                        Button {
                            store.addNewVehicle(
                                name: name.isEmpty ? "我的爱车" : name,
                                plate: plate.isEmpty ? "沪A·88888" : plate,
                                isEV: isEV,
                                nakedPrice: Double(nakedPrice) ?? 250000,
                                tax: Double(tax) ?? 0,
                                firstInsurance: Double(firstIns) ?? 6500,
                                initialOdo: Int(initialOdo) ?? 15,
                                colorName: colorName,
                                vin: vin
                            )
                            dismiss()
                        } label: {
                            Text("🎉 确认建档入库")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 1.0, green: 0.44, blue: 0.24), AutoColor.accentOrange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: AutoColor.accentOrange.opacity(0.45), radius: 12, x: 0, y: 6)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("🚘 添加新车入库")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { dismiss() }
                }
            }
        }
        .preferredColorScheme(store.isDarkMode ? .dark : .light)
    }

    private func field(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10.5, weight: .semibold))
                .foregroundStyle(.secondary)
            TextField("", text: text)
                .keyboardType(keyboard)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .padding(.horizontal, 11)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(Color.primary.opacity(0.06))
                        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous).strokeBorder(Color.white.opacity(0.18), lineWidth: 1))
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
