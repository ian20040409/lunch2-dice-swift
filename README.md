# 午餐骰子 (Lunch Dice) 🎲

一個幫助你決定午餐吃什麼的 iOS 應用程式，使用 Swift 和 SwiftUI 開發。

## 功能特色 ✨

### 🎲 隨機決定
- 一鍵隨機選擇午餐選項
- 流暢的動畫效果和震動回饋
- 可複製結果到剪貼簿
- 查看歷史決定紀錄

### 🗺️ 地圖搜尋
- 顯示使用者當前位置
- 整合 Google Maps 搜尋附近餐廳
- 支援位置權限管理
- 提供網頁版和 App 版搜尋連結

### ⚙️ 設定與管理
- 新增自訂午餐選項
- 查看所有可選選項
- 刪除不想要的選項
- 還原預設選項列表
- 查看和清空歷史紀錄

## 預設選項 🍽️

應用程式內建以下午餐選項：
- 便當
- 牛肉麵
- 滷肉飯
- 拉麵
- 壽司
- 麵線
- 咖哩飯
- 義大利麵
- 炸雞
- 鍋燒意麵
- 越南河粉
- 韓式拌飯
- 炒飯
- 披薩
- 三明治
- 沙拉

## 技術特點 🛠️

- **架構**: MVVM (Model-View-ViewModel)
- **UI框架**: SwiftUI
- **資料持久化**: UserDefaults
- **地圖整合**: MapKit
- **定位服務**: CoreLocation
- **反應式程式設計**: Combine Framework

## 專案結構 📁

```
lunch2-dice-swift/
├── lunch2/
│   ├── MyApp.swift              # 應用程式入口
│   ├── ContentView.swift        # 主要視圖（TabView）
│   ├── LunchViewModel.swift     # 業務邏輯與狀態管理
│   ├── LunchTab.swift           # 隨機決定頁面
│   ├── MapTab.swift             # 地圖搜尋頁面
│   ├── SettingsTab.swift        # 設定頁面
│   └── LunchDefaults.swift      # 預設選項常數
├── lunch2Tests/                 # 單元測試
└── lunch2UITests/               # UI 測試
```

## 系統需求 📱

- iOS 14.0 或更高版本
- Xcode 12.0 或更高版本
- Swift 5.0 或更高版本

## 安裝與執行 🚀

1. Clone 此專案
```bash
git clone https://github.com/ian20040409/lunch2-dice-swift.git
```

2. 開啟 Xcode 專案
```bash
cd lunch2-dice-swift
open lunch2.xcodeproj
```

3. 選擇模擬器或實體裝置

4. 按下 `Cmd + R` 執行專案

## 使用說明 📖

### 隨機決定午餐
1. 開啟 App，預設在「隨機決定」頁面
2. 點擊「幫我決定」按鈕
3. App 會從選項列表中隨機選擇一個
4. 可以點擊複製按鈕將結果複製到剪貼簿

### 新增自訂選項
1. 在「隨機決定」頁面下方的輸入框輸入選項名稱
2. 點擊「新增」按鈕
3. 新選項會自動加入到選項列表中

### 管理選項
1. 切換到「設定」頁籤
2. 選擇「查看所有選項」可以查看和刪除選項
3. 選擇「還原預設選項」可以恢復到初始狀態

### 使用地圖搜尋
1. 切換到「地圖搜尋」頁籤
2. 允許 App 存取位置資訊（如果需要）
3. 點擊「在 Google Maps 搜尋餐廳」按鈕
4. 會開啟 Google Maps 搜尋附近的餐廳

## 主要功能實作 💡

### 資料持久化
使用 `UserDefaults` 儲存：
- 使用者自訂的選項列表
- 歷史決定紀錄

### 動畫效果
- Spring 動畫用於按鈕互動
- 旋轉動畫用於骰子圖示
- 縮放動畫用於結果顯示

### 觸覺回饋
使用 `UIImpactFeedbackGenerator` 提供觸覺反饋，增強使用者體驗

## 授權 📄

本專案採用 MIT License 授權 - 詳見 [LICENSE](LICENSE) 檔案

## 作者 👨‍💻

**LNU** - [ian20040409](https://github.com/ian20040409)

## 貢獻 🤝

歡迎提交 Issues 和 Pull Requests！

## 更新日誌 📝

### v1.0.0 (2025-04-17)
- 初始版本發布
- 實作隨機決定功能
- 整合地圖搜尋
- 新增設定頁面

---

如果這個專案對你有幫助，請給個 ⭐️ 吧！
