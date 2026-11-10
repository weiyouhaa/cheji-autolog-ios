import Foundation
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case cockpit
    case lifecycle
    case fuel
    case maintenance
    case insurance

    var id: String { rawValue }
}

@MainActor
final class VehicleStore: ObservableObject {
    @Published var vehicles: [Vehicle] = [] {
        didSet { saveToStorage() }
    }
    @Published var currentVehicleId: String = "bmw330" {
        didSet { UserDefaults.standard.set(currentVehicleId, forKey: "autolog_current_vid") }
    }
    @Published var activeTab: AppTab = .cockpit
    @Published var isDarkMode: Bool = true
    @Published var quickLogPresented: Bool = false
    @Published var selectedQuickLogCategory: QuickLogCategory = .fuel
    @Published var addVehiclePresented: Bool = false
    @Published var lifecycleFilter: String = "all"
    @Published var toastMessage: String? = nil

    private let storageKey = "autolog_vehicles_v1"

    init() {
        loadFromStorage()
    }

    var currentVehicle: Vehicle {
        get {
            vehicles.first(where: { $0.id == currentVehicleId }) ?? vehicles.first ?? SampleVehicles.bmw330
        }
        set {
            if let idx = vehicles.firstIndex(where: { $0.id == newValue.id }) {
                vehicles[idx] = newValue
            }
        }
    }

    func switchVehicle(_ id: String) {
        guard vehicles.contains(where: { $0.id == id }) else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            currentVehicleId = id
        }
        showToast("已切换至：\(currentVehicle.fullName)")
    }

    func toggleNextVehicle() {
        guard vehicles.count > 1 else { return }
        if let idx = vehicles.firstIndex(where: { $0.id == currentVehicleId }) {
            let nextIdx = (idx + 1) % vehicles.count
            switchVehicle(vehicles[nextIdx].id)
        }
    }

    func openQuickLog(_ category: QuickLogCategory = .fuel) {
        selectedQuickLogCategory = category
        quickLogPresented = true
    }

    func showToast(_ message: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            toastMessage = message
        }
        Task {
            try? await Task.sleep(nanoseconds: 2_600_000_000)
            if self.toastMessage == message {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.toastMessage = nil
                }
            }
        }
    }

    func resetSampleData() {
        vehicles = [SampleVehicles.bmw330, SampleVehicles.nioEt5t]
        currentVehicleId = "bmw330"
        showToast("已恢复出厂演示数据")
    }

    // MARK: - Iteration 01: Tire & TPMS Matrix Actions
    func inflateAllTiresToStandard(frontBar: Double = 2.50, rearBar: Double = 2.60) {
        var car = currentVehicle
        for i in car.tires.indices {
            if car.tires[i].id.hasPrefix("F") {
                car.tires[i].pressureBar = frontBar
            } else {
                car.tires[i].pressureBar = rearBar
            }
        }
        currentVehicle = car
        showToast("🛞 已将四轮充气校准至标准胎压 (前 \(String(format: "%.1f", frontBar)) / 后 \(String(format: "%.1f", rearBar)) Bar)")
    }

    func updateSingleTire(id: String, pressureBar: Double, treadMm: Double, patchCount: Int) {
        var car = currentVehicle
        if let idx = car.tires.firstIndex(where: { $0.id == id }) {
            car.tires[idx].pressureBar = pressureBar
            car.tires[idx].treadMm = treadMm
            car.tires[idx].patchCount = patchCount
            currentVehicle = car
            showToast("✅ 已更新「\(car.tires[idx].positionName)」胎压与胎纹档案")
        }
    }

    // MARK: - Iteration 02: Auto Loan & Financing Actions
    func recordLoanMonthlyPayment() {
        var car = currentVehicle
        guard car.purchase.loanPlan.paidMonths < car.purchase.loanPlan.totalMonths else {
            showToast("🎉 恭喜！本车分期贷款已全部结清！")
            return
        }
        car.purchase.loanPlan.paidMonths += 1
        let paid = car.purchase.loanPlan.paidMonths
        let total = car.purchase.loanPlan.totalMonths
        let monthly = car.purchase.loanPlan.monthlyPayment
        car.purchase.loanStatus = paid >= total ? "已结清 (解押办结)" : "分期 \(paid)/\(total) 期"

        let event = TimelineEvent(
            date: Self.fullDateString(),
            cat: "买车",
            color: "purple",
            title: "车贷月供扣款 · 第 \(paid)/\(total) 期",
            cost: String(format: "-¥%.0f", monthly),
            odo: "\(car.odometer.formatted()) km",
            tags: [car.purchase.loanPlan.bankName, "剩余 \(total - paid) 期"]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("💳 已记入第 \(paid)/\(total) 期车贷月供 (¥\(Int(monthly)))")
    }

    func settleLoanEarly() {
        var car = currentVehicle
        let saved = car.purchase.loanPlan.estimatedInterestSavedOnEarlyPayoff
        car.purchase.loanPlan.paidMonths = car.purchase.loanPlan.totalMonths
        car.purchase.loanPlan.isFinanced = false
        car.purchase.loanStatus = "提前结清 (省息 ¥\(Int(saved)))"
        currentVehicle = car
        showToast("🎉 已办理车贷提前结清，累计节省利息约 ¥\(Int(saved))！")
    }

    // MARK: - Iteration 03: Driving Trip & Scenario Logbook
    func logQuickDrivingTrip(scenario: String) {
        var car = currentVehicle
        let todayShort = Self.shortDateString()
        let isEV = car.isEV

        let trip: DrivingTrip
        if scenario.contains("高速") {
            trip = DrivingTrip(date: todayShort, title: "高速巡航路段打卡", scenario: "🛣️ 高速巡航", distanceKm: 120, avgSpeedKmh: 102, consumption: isEV ? 15.6 : 6.3)
        } else if scenario.contains("市区") {
            trip = DrivingTrip(date: todayShort, title: "城市内环通勤打卡", scenario: "🏙️ 市区通勤", distanceKm: 28, avgSpeedKmh: 25, consumption: isEV ? 13.2 : 9.1)
        } else {
            trip = DrivingTrip(date: todayShort, title: "周末郊野山路自驾", scenario: "⛰️ 跑山露营", distanceKm: 95, avgSpeedKmh: 58, consumption: isEV ? 14.8 : 7.6)
        }

        car.odometer += trip.distanceKm
        car.trips.insert(trip, at: 0)
        currentVehicle = car
        showToast("🧭 已记录「\(trip.scenario)」+\(trip.distanceKm)km · 实测能耗 \(trip.consumption)\(car.consumptionUnit)")
    }

    // MARK: - Iteration 05: Timeline CRUD (Update & Delete Events)
    func updateTimelineEvent(id: UUID, title: String, cost: String, odo: String) {
        var car = currentVehicle
        if let idx = car.timeline.firstIndex(where: { $0.id == id }) {
            car.timeline[idx].title = title
            car.timeline[idx].cost = cost
            car.timeline[idx].odo = odo
            currentVehicle = car
            showToast("✅ 已更新「\(title)」账单明细")
        }
    }

    func deleteTimelineEvent(id: UUID) {
        var car = currentVehicle
        guard car.timeline.count > 1 else {
            showToast("⚠️ 至少保留 1 条初始建档记录")
            return
        }
        if let idx = car.timeline.firstIndex(where: { $0.id == id }) {
            let removed = car.timeline.remove(at: idx)
            currentVehicle = car
            showToast("🗑️ 已删除记录：\(removed.title)")
        }
    }

    // MARK: - Iteration 07: New Car Delivery PDI Checklist Actions
    func togglePDIItem(id: String) {
        var car = currentVehicle
        if let idx = car.purchase.pdiItems.firstIndex(where: { $0.id == id }) {
            car.purchase.pdiItems[idx].passed.toggle()
            currentVehicle = car
        }
    }

    func markAllPDIItemsPassed() {
        var car = currentVehicle
        for i in car.purchase.pdiItems.indices {
            car.purchase.pdiItems[i].passed = true
        }
        currentVehicle = car
        showToast("🎖️ 提车 PDI 6 大核心指标已全部验收合格归档！")
    }

    // MARK: - Iteration 08: Monthly Budget Target & Radar Actions
    func cycleMonthlyBudgetTarget() {
        var car = currentVehicle
        let tiers: [Double] = [1500, 2200, 3000, 4500]
        if let idx = tiers.firstIndex(of: car.monthlyBudgetTarget) {
            car.monthlyBudgetTarget = tiers[(idx + 1) % tiers.count]
        } else {
            car.monthlyBudgetTarget = 2200
        }
        currentVehicle = car
        showToast("💰 本月养车预算上限已调整为 ¥\(Int(car.monthlyBudgetTarget).formatted())")
    }

    // MARK: - 1. Add Fuel / Charging Log
    func submitFuelLog(odo: Int, cost: Double, price: Double, subType: String, isFullTank: Bool, stationNote: String) {
        var car = currentVehicle
        let deltaKm = max(10, odo - car.odometer)
        let safePrice = max(0.01, price)
        let volume = (cost / safePrice * 10).rounded() / 10
        let cons = ((volume / Double(deltaKm)) * 100 * 100).rounded() / 100

        car.odometer = max(car.odometer, odo)
        car.totalFuelSpend += cost.rounded()
        car.currentMonthSpend += cost.rounded()
        car.avgConsumption = ((car.avgConsumption * 0.8 + cons * 0.2) * 100).rounded() / 100
        car.energyCostPerKm = ((cost / Double(deltaKm)) * 100).rounded() / 100

        let todayShort = Self.shortDateString()
        let todayFull = Self.fullDateString()

        let newLog = FuelLog(
            date: todayShort,
            odo: car.odometer,
            deltaKm: deltaKm,
            volume: volume,
            price: safePrice,
            cost: cost,
            consumption: cons,
            station: stationNote.isEmpty ? "快捷记账站点" : stationNote,
            full: isFullTank,
            note: "\(subType) · \(isFullTank ? "满箱跳枪" : "阶段加注")"
        )
        car.fuelLogs.insert(newLog, at: 0)

        let event = TimelineEvent(
            date: todayFull,
            cat: "加油",
            color: "amber",
            title: "\(subType) · \(stationNote)",
            cost: String(format: "-¥%.1f", cost),
            odo: "\(car.odometer.formatted()) km",
            tags: ["+\(deltaKm) km", String(format: "%.1f %@", volume, car.isEV ? "kWh" : "L"), String(format: "实测 %.2f%@", cons, car.consumptionUnit)]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("✅ 已记入「\(subType)」并刷新百公里能耗曲线！")
    }

    // MARK: - 2. Add Maintenance & Reset Lifespan
    func submitMaintenance(odo: Int, cost: Double, shopType: String, checkedIndices: Set<Int>, shopNote: String) {
        var car = currentVehicle
        let todayFull = Self.fullDateString()
        var resetNames: [String] = []

        for idx in checkedIndices.sorted() {
            if idx < car.maintenanceParts.count {
                car.maintenanceParts[idx].usedKm = 0
                car.maintenanceParts[idx].usedDays = 0
                car.maintenanceParts[idx].pct = 100
                car.maintenanceParts[idx].lastDate = "\(todayFull) @ \(odo.formatted())km"
                resetNames.append(car.maintenanceParts[idx].name)
            }
        }

        car.odometer = max(car.odometer, odo)
        car.totalMaintSpend += cost.rounded()
        car.healthScore = min(100, max(car.healthScore, 98))

        let record = ServiceRecord(
            date: todayFull,
            type: "定期保养 (\(shopType))",
            shop: shopNote.isEmpty ? shopType : shopNote,
            odo: car.odometer,
            cost: cost,
            items: resetNames.isEmpty ? ["常规全车健检"] : resetNames
        )
        car.serviceRecords.insert(record, at: 0)

        var tags = [shopType]
        tags.append(contentsOf: resetNames.prefix(2))
        tags.append("寿命已重置100%")

        let event = TimelineEvent(
            date: todayFull,
            cat: "保养",
            color: "blue",
            title: "定期保养 · \(shopNote)",
            cost: String(format: "-¥%.1f", cost),
            odo: "\(car.odometer.formatted()) km",
            tags: tags
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("🔧 已完成保养归档，\(resetNames.count) 项配件寿命已重置为 100%！")
    }

    // MARK: - 3. Add Repair Record
    func submitRepair(odo: Int, cost: Double, partArea: String, claimType: String, symptomNote: String, warrantyNote: String) {
        var car = currentVehicle
        let todayFull = Self.fullDateString()
        car.odometer = max(car.odometer, odo)
        car.totalMaintSpend += cost.rounded()

        let record = ServiceRecord(
            date: todayFull,
            type: "\(partArea) · \(symptomNote)",
            shop: claimType,
            odo: car.odometer,
            cost: cost,
            items: [partArea, claimType, warrantyNote]
        )
        car.serviceRecords.insert(record, at: 0)

        let event = TimelineEvent(
            date: todayFull,
            cat: "维修",
            color: "rose",
            title: "\(partArea) · \(symptomNote)",
            cost: String(format: "-¥%.1f", cost),
            odo: "\(car.odometer.formatted()) km",
            tags: [claimType, warrantyNote]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("🛠️ 已记入「\(partArea)」故障维修档案！")
    }

    // MARK: - 4. Add Insurance Renewal
    func submitInsurance(company: String, compulsory: Double, commercial: Double, checkedItems: [String], benefitNote: String) {
        var car = currentVehicle
        let todayFull = Self.fullDateString()
        let total = compulsory + commercial

        car.insurance.company = company
        car.insurance.compulsory = compulsory
        car.insurance.commercial = commercial
        car.insurance.totalPremium = total
        car.insurance.daysRemaining = 365
        car.totalInsuranceSpend += total.rounded()

        let event = TimelineEvent(
            date: todayFull,
            cat: "保险",
            color: "emerald",
            title: "年度车险续保 · \(company)",
            cost: String(format: "-¥%.0f", total),
            odo: "\(car.odometer.formatted()) km",
            tags: [String(format: "交强 ¥%.0f", compulsory), String(format: "商业 ¥%.0f", commercial), benefitNote]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("🛡️ 已更新年度车险保单，365 天保障倒计时已激活！")
    }

    // MARK: - 5. Add On-Road Expense
    func submitRoadExpense(expenseType: String, cost: Double, odoOrPoints: Int, detailNote: String) {
        var car = currentVehicle
        let todayFull = Self.fullDateString()
        car.totalOtherSpend += cost.rounded()

        if expenseType.contains("违章") && odoOrPoints > 0 {
            car.insurance.compliance.violations = "已处理 · 记 \(odoOrPoints) 分"
        }

        let event = TimelineEvent(
            date: todayFull,
            cat: "上路",
            color: "purple",
            title: "\(expenseType) · \(detailNote)",
            cost: String(format: "-¥%.1f", cost),
            odo: "\(car.odometer.formatted()) km",
            tags: [expenseType, "日常车务"]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("🛣️ 已记入「\(expenseType)」日常车务支出！")
    }

    // MARK: - 6. Add Modification / Purchase Asset
    func submitModification(modType: String, cost: Double, odo: Int, detailNote: String) {
        var car = currentVehicle
        let todayFull = Self.fullDateString()
        car.odometer = max(car.odometer, odo)
        car.purchase.accessories += cost.rounded()
        car.purchase.totalLanded += cost.rounded()

        let event = TimelineEvent(
            date: todayFull,
            cat: "买车",
            color: "purple",
            title: "\(modType) · \(detailNote)",
            cost: String(format: "-¥%.0f", cost),
            odo: "\(car.odometer.formatted()) km",
            tags: [modType, "计入车辆资产"]
        )
        car.timeline.insert(event, at: 0)
        currentVehicle = car
        showToast("✨ 已记入「\(modType)」并更新车辆总资产！")
    }

    // MARK: - Add New Vehicle to Garage
    func addNewVehicle(name: String, plate: String, isEV: Bool, nakedPrice: Double, tax: Double, firstInsurance: Double, initialOdo: Int, colorName: String, vin: String) {
        let newId = "car_\(Int(Date().timeIntervalSince1970))"
        let landed = nakedPrice + tax + firstInsurance + 500
        let newCar = Vehicle(
            id: newId,
            name: name,
            fullName: name,
            plate: plate,
            isEV: isEV,
            energyType: isEV ? "纯电 / 快充" : "95# 汽油",
            vin: vin.isEmpty ? "LBVNEW88990011223" : vin,
            engineNo: isEV ? "EDS-Dual-Motor" : "2.0T-Turbo",
            colorName: colorName.isEmpty ? "曜石黑 / 摩卡内" : colorName,
            purchaseDate: Self.fullDateString(),
            daysOwned: 1,
            odometer: max(10, initialOdo),
            dailyKm: 35.0,
            avgConsumption: isEV ? 14.5 : 7.8,
            consumptionUnit: isEV ? "kWh/100km" : "L/100km",
            energyCostPerKm: isEV ? 0.15 : 0.62,
            totalFuelSpend: 0,
            totalMaintSpend: 0,
            totalInsuranceSpend: firstInsurance,
            totalOtherSpend: 500,
            purchase: PurchaseInfo(
                nakedPrice: nakedPrice,
                tax: tax,
                firstInsurance: firstInsurance,
                regAndPlate: 500,
                accessories: 0,
                totalLanded: landed,
                estimatedResale: (nakedPrice * 0.88).rounded(),
                dealer: "官方授权交付中心",
                loanStatus: "已提车建档"
            ),
            healthScore: 100,
            nextAlert: "首保提醒 · 剩余 5,000 km",
            fuelLogs: [],
            maintenanceParts: SampleVehicles.bmw330.maintenanceParts,
            serviceRecords: [],
            insurance: SampleVehicles.bmw330.insurance,
            timeline: [
                TimelineEvent(
                    date: Self.fullDateString(),
                    cat: "买车",
                    color: "purple",
                    title: "提车建档 · \(name)",
                    cost: String(format: "-¥%.0f", landed),
                    odo: "\(initialOdo) km",
                    tags: [plate, String(format: "裸车 ¥%.1f万", nakedPrice / 10000), "新车入库"]
                )
            ]
        )
        vehicles.append(newCar)
        currentVehicleId = newId
        showToast("🎉 新车「\(name)」已成功入库建档！")
    }

    // MARK: - Persistence
    private func saveToStorage() {
        if let data = try? JSONEncoder().encode(vehicles) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadFromStorage() {
        if let savedVid = UserDefaults.standard.string(forKey: "autolog_current_vid") {
            currentVehicleId = savedVid
        }
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Vehicle].self, from: data),
           !decoded.isEmpty {
            vehicles = decoded
        } else {
            vehicles = [SampleVehicles.bmw330, SampleVehicles.nioEt5t]
        }
    }

    private static func shortDateString() -> String {
        let f = DateFormatter()
        f.dateFormat = "MM-dd"
        return f.string(from: Date())
    }

    private static func fullDateString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
}
