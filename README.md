# 车记 AutoLog — iOS 27 Liquid Glass 车辆全生命周期记录 App

**车记 (AutoLog)** 是一款采用 **iOS 27 Liquid Glass（液态光学玻璃）** 设计语言打造的原生 SwiftUI iOS 爱车全生命周期管家。从 **买车提车、落户上牌、保险续保** 到 **里程追踪、满箱油耗/电耗曲线、易损件双维保养预警、故障维修理赔与 TCO 真实拥车成本透视**，全方位优雅记录爱车的每一程。

---

## 📦 安装包与在线设计稿

- **iOS 安装包 (`.ipa`)**：仓库根目录及 GitHub Releases 中直接提供编译打包好的 [`AutoLog.ipa`](./AutoLog.ipa)（可通过 **TrollStore / AltStore / SideStore / Sideloadly / 爱思助手** 签名安装至真机）。
- **交互式 iOS 27 设计工作台 (`HTML`)**：打开仓库根目录的 [`index.html`](./index.html) 即可在浏览器中体验 **单机交互模式** 与 **5 屏全量画板总览模式**。

---

## ✨ 核心功能模块

### 1. 🏎️ 爱车座舱总览 (`CockpitHomeView`)
- **车型剪影与健康度**：矢量绘制燃油轿跑（如 BMW 330Li）与纯电猎装旅行车（如 蔚来 ET5T），实时呈现车况评分与陪伴天数。
- **机械感里程牌与日均持有成本**：不仅统计日均里程（`km/天`），更将 **（落地总价 + 历年养车支出 - 当前二手残值）÷ 拥车天数** 折算为真实的 **日均拥车成本（`¥/天`）**。
- **四维 Liquid Glass Bento 磁贴**：一眼掌握百公里实测油耗/电耗、易损件保养倒计时、车险到期/违章状态、累计养车支出与残值。

### 2. 🎖️ 买车落户与全周期 TCO 账本 (`LifecycleTCOView`)
- **提车资产档案**：记录裸车开票价、购置税、上牌费、首年车险、隐形车衣/改色膜等精品改装与当前估值。
- **TCO 拥车总成本透视**：按燃油/补能、历年保险、保养维修、停车/ETC/美容四维比例拆分，并支持按分类筛选 **从买车到上路的全生命周期时间轴**。

### 3. ⛽ 里程与油耗/电耗实验室 (`FuelOdometerLabView`)
- **双能源自适应**：支持燃油车（`95# / 98#`，单位 `L/100km`）与纯电/换电车型（`7kW 家充谷电 / 换电站 / 超充`，单位 `kWh/100km`）无缝切换。
- **跳枪实测趋势曲线**：绘制近 5 次加注的百公里能耗波动与「黄金右脚」基准线，自动计算单公里能源成本（`¥/km`）。

### 4. 🔧 维保健康度与车险合规数字手套箱 (`MaintenanceAndInsuranceView`)
- **里程 × 时间双维寿命进度条**：监控机油机滤、火花塞、制动液、空调滤芯、四轮动平衡换位等关键部件，临近阈值自动变琥珀色提醒。
- **车险保单与 NCD 出险涨价试算**：拆解交强险与商业险保额/保费，内置 **🧮 出险次年保费涨价试算器**，帮车主快速决策小刮蹭走保险还是自费。
- **数字手套箱**：收纳年检免检倒计时、违章记分、高速 ETC 账单与一键复制车架号 `VIN`。

### 5. ➕ 极速记一笔 · 6 套专属动态表单 (`QuickLogSheetView`)
点击底部悬浮胶囊中央的 3D 液态玻璃球 **`＋`** 按钮，切换分类即可呈现 **6 套完全独立定制的专业表单**：
1. **⛽ 加油/补能**：标号/补能方式选择 + 满箱跳枪开关 + 里程/金额/单价三联动实时反算百公里油耗。
2. **🔧 定期保养**：服务门店选择 + **本车易损件多选勾选框**（勾选并提交后，**自动将对应配件寿命进度条重置为 `100%`**）。
3. **🛠️ 故障维修**：故障部位 + 理赔结算方式（自费 / 厂家质保索赔 / 走车损险 / 对方全责），实时提示次年保费影响。
4. **🛡️ 续保出险**：保险公司选择 + 6 大商业险种多选框 + 交强/商业保费汇总与日均保费折算。
5. **🛣️ 停车/车务**：一键切换停车费、高速 ETC、洗车美容、违章罚款记分、上线年检预设。
6. **✨ 改装/买车**：记录隐形车衣、锻造轮毂/卡钳、行车记录仪或购置税费，自动计入车辆固定资产。

---

## 🛠️ 本地编译与打包 IPA

```bash
# 1. 使用 XcodeGen 生成 Xcode 工程
xcodegen generate

# 2. 编译 Release 版本并打包 AutoLog.ipa
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild \
  -project AutoLog.xcodeproj \
  -scheme AutoLog \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath build \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO build

mkdir -p Payload
cp -R build/Build/Products/Release-iphoneos/AutoLog.app Payload/
codesign --force --deep --sign - Payload/AutoLog.app
zip -r AutoLog.ipa Payload
rm -rf Payload
```
