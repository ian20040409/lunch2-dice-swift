import SwiftUI

struct ContentView: View {
    @StateObject private var vm = LunchViewModel()
    
    var body: some View {
        TabView {
            LunchTab(vm: vm)
                .tabItem {
                    Label("隨機決定", systemImage: "dice")
                }
            
            MapTab()
                .tabItem {
                    Label("地圖搜尋", systemImage: "map")
                }
        }
        
    }
}
