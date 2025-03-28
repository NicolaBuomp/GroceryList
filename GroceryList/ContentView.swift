//
//  ContentView.swift
//  GroceryList
//
//  Created by Nicola Buompane on 28/03/25.
//

import SwiftData
import SwiftUI
import TipKit

extension View {
    @ViewBuilder
    func conditionalPopoverTip<T: Tip>(_ condition: Bool, tip: T) -> some View {
        if condition {
            popoverTip(tip)
        } else {
            self
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var itemTextFieldValue: String = ""
    @FocusState private var isFocused: Bool

    let buttonTip = ButtonTip()

    func setupTips() {
        do {
            try Tips.resetDatastore()
            Tips.showAllTipsForTesting()
            try Tips.configure([
                .displayFrequency(.immediate),
            ])
        } catch {
            print("Error setting up tips: \(error.localizedDescription)")
        }
    }

    init() {
        setupTips()
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical, 2)
                        .foregroundStyle(item.isCompleted ? Color.green : Color.primary)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button("Done", systemImage: item.isCompleted ? "xmark.circle.fill" : "checkmark") {
                                item.isCompleted.toggle()
                            }
                            .tint(item.isCompleted ? .red : .green)
                        }
                }
            }
            .navigationBarTitle("Grocery List")
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to your cart!"))
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    TextField("Add item...", text: $itemTextFieldValue)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.tertiary)
                        .cornerRadius(12)
                        .font(.title.weight(.light))
                        .focused($isFocused)
                        .onSubmit {
                            withAnimation {
                                if itemTextFieldValue.isEmpty { return }
                                modelContext.insert(Item(title: itemTextFieldValue, isCompleted: false))
                                itemTextFieldValue = ""
                                isFocused = false
                            }
                        }
                        .conditionalPopoverTip(items.isEmpty, tip: buttonTip)

                    Button {
                        guard !itemTextFieldValue.isEmpty else {
                            return
                        }
                        modelContext.insert(Item(title: itemTextFieldValue, isCompleted: false))
                        itemTextFieldValue = ""
                        isFocused = false
                    } label: {
                        Text("Add")
                            .font(.title2.weight(.medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.extraLarge)
                }
                .padding()
                .background(.bar)
            }
        }
    }
}

#Preview("Empty list") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

#Preview("With items") {
    let sampleData: [Item] = [
        Item(title: "Banana", isCompleted: true),
        Item(title: "Apples", isCompleted: false),
        Item(title: "Oranges", isCompleted: .random()),
    ]

    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for item in sampleData {
        container.mainContext.insert(item)
    }

    return ContentView()
        .modelContainer(container)
}
