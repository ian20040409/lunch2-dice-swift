import SwiftUI
import UIKit

#if canImport(UIKit)
extension View {
    /// Dismisses the keyboard by resigning first responder
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct LunchTab: View {
    @ObservedObject var vm: LunchViewModel
    @State private var customText = ""
    @State private var showAll = false
    @State private var showHistory = false
    @State private var selectedToDelete: Set<String> = []
    @State private var themeColor: Color = .blue
    @State private var fontColor: Color = .primary
    @State private var showSettings = false
    @State private var diceRotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 50) {
                    Text("午餐要吃什麼？")
                        .font(.largeTitle).bold()
                        .padding(.top, 80)
                        .foregroundColor(fontColor)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Text(vm.resultText)
                        .font(.title)
                        .foregroundColor(vm.animateResult ? .green : fontColor)
                        .scaleEffect(vm.animateResult ? 1.5 : 1.0)
                        .opacity(vm.animateResult ? 1.0 : 0.8)
                        .animation(.interpolatingSpring(stiffness: 500, damping: 5), value: vm.animateResult)
                        .onChange(of: vm.animateResult) { newValue in
                            if newValue {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }
                        }
                }
                VStack(spacing: 36) {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        withAnimation(.spring()) {
                            diceRotation += 360
                            vm.decideLunch()
                        }
                    } label: {
                        Label("幫我決定", systemImage: "dice.fill")
                            .rotationEffect(.degrees(diceRotation))
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    HStack {
                        TextField("輸入自訂選項...", text: $customText)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done)
                            .onSubmit {
                                hideKeyboard()
                            }
                        Button {
                            withAnimation(.spring()) {
                                vm.addOption(customText)
                                customText = ""
                            }
                        } label: {
                            Label("新增", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.bordered)
                    }

                    Button {
                        withAnimation(.spring()) {
                            showSettings = true
                        }
                    } label: {
                        Label("設定", systemImage: "gearshape")
                    }
                    .sheet(isPresented: $showSettings) {
                        NavigationStack {
                            List {
                                Button("還原預設選項") {
                                    withAnimation(.spring()) {
                                        vm.restoreDefaultOptions()
                                        selectedToDelete.removeAll()
                                    }
                                }
                                Button("查看歷史紀錄") {
                                    withAnimation(.spring()) {
                                        showHistory = true
                                        showSettings = false
                                    }
                                }
                                Button("查看所有選項") {
                                    withAnimation(.spring()) {
                                        showAll = true
                                        showSettings = false
                                        selectedToDelete.removeAll()
                                    }
                                }
                            }
                            .navigationTitle("設定")
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("關閉") {
                                        withAnimation(.spring()) {
                                            showSettings = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .scaleEffect(1.02)
                .animation(.easeInOut(duration: 0.3), value: vm.resultText)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .sheet(isPresented: $showHistory) {
            NavigationStack {
                List {
                    ForEach(vm.history, id: \.self) { Text($0) }
                }
                .navigationTitle("歷史紀錄")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation(.spring()) {
                                vm.clearHistory()
                                showHistory = false
                            }
                        } label: {
                            Label("清空歷史", systemImage: "trash")
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("關閉") {
                            withAnimation(.spring()) {
                                showHistory = false
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAll) {
            NavigationStack {
                List {
                    ForEach(vm.options, id: \.self) { option in
                        HStack {
                            Text(option)
                            Spacer()
                            if selectedToDelete.contains(option) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedToDelete.contains(option) {
                                selectedToDelete.remove(option)
                            } else {
                                selectedToDelete.insert(option)
                            }
                        }
                    }

                    if !selectedToDelete.isEmpty {
                        Button("刪除選取項目") {
                            withAnimation(.spring()) {
                                vm.options.removeAll { selectedToDelete.contains($0) }
                                selectedToDelete.removeAll()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("所有午餐選項")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("關閉") {
                            withAnimation(.spring()) {
                                showAll = false
                            }
                        }
                    }
                }
            }
        }
    }
}
