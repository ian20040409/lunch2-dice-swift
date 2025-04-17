import SwiftUI
import Combine
import CoreLocation

class LunchViewModel: ObservableObject {
    @Published var options: [String]
    @Published var history: [String]
    @Published var resultText: String = ""
    @Published var animateResult = false
    
    
    private let optionsKey = "lunchOptions"
    private let historyKey = "lunchHistory"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let savedOptions = UserDefaults.standard.stringArray(forKey: optionsKey)
        self.options = savedOptions ?? [
            "便當","牛肉麵","滷肉飯","拉麵","壽司","麵線",
            "咖哩飯","義大利麵","炸雞","鍋燒意麵",
            "越南河粉","韓式拌飯","炒飯","披薩","三明治","沙拉"
        ]
        self.history = UserDefaults.standard.stringArray(forKey: historyKey) ?? []
        
        $options
            .sink { UserDefaults.standard.set($0, forKey: self.optionsKey) }
            .store(in: &cancellables)
        $history
            .sink { UserDefaults.standard.set($0, forKey: self.historyKey) }
            .store(in: &cancellables)
    }
    
    func decideLunch() {
        guard !options.isEmpty else { return }
        let choice = options.randomElement()!
        resultText = "你可以吃：\(choice)"
        history.insert(choice, at: 0)
        
        animateResult = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateResult = false
        }
    }
    
    func addOption(_ newOption: String) {
        let trimmed = newOption.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        options.append(trimmed)
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    func restoreDefaultOptions() {
        options = LunchDefaults.defaultOptions
    }
}
