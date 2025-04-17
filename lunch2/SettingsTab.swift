//
//  SettingsTab.swift
//  lunch2
//
//  Created by 林恩佑 on 2025/4/17.
//

import Foundation
import SwiftUI

struct SettingsSheet: View {
    @Binding var showSettings: Bool
    @Binding var showHistory: Bool
    @Binding var showAll: Bool
    @Binding var selectedToDelete: Set<String>
    var restoreDefaultOptions: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Button("還原預設選項") {
                    withAnimation(.spring()) {
                        restoreDefaultOptions()
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

struct SettingsTab: View {
    @State private var showHistory = false
    @State private var showAll = false
    @State private var selectedToDelete: Set<String> = []
    @ObservedObject var vm: LunchViewModel

    var body: some View {
        NavigationStack {
            List {
                Button("查看歷史紀錄") {
                    withAnimation(.spring()) {
                        showHistory = true
                    }
                }
                Button("查看所有選項") {
                    withAnimation(.spring()) {
                        showAll = true
                        selectedToDelete.removeAll()
                    }
                }
                Button("還原預設選項") {
                    withAnimation(.spring()) {
                        vm.restoreDefaultOptions()
                        selectedToDelete.removeAll()
                    }
                }
            }
            .navigationTitle("設定")
            .sheet(isPresented: $showHistory) {
                NavigationStack {
                    List {
                        ForEach(vm.history, id: \.self) { Text($0) }
                    }
                    .navigationTitle("歷史紀錄")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.spring()) {
                                showHistory = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                withAnimation(.spring()) {
                                    vm.clearHistory()
                                    showHistory = false
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("清空歷史")
                                }
                            }
                            .foregroundColor(.red)
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
                    }
                    .navigationTitle("所有午餐選項")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.spring()) {
                                showAll = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        }
                        if !selectedToDelete.isEmpty {
                            ToolbarItem(placement: .bottomBar) {
                                Button("刪除選取項目") {
                                    withAnimation(.spring()) {
                                        vm.options.removeAll { selectedToDelete.contains($0) }
                                        selectedToDelete.removeAll()
                                    }
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
    }
}
