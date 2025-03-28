//
//  ContentView.swift
//  GroceryList
//
//  Created by Nicola Buompane on 28/03/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    func addEssentialFoods() {
        modelContext.insert(Item(title: "Banana", isCompleted: true))
        modelContext.insert(Item(title: "Apples", isCompleted: false))
        modelContext.insert(Item(title: "Oranges", isCompleted: .random()))
        modelContext.insert(Item(title: "Oranges", isCompleted: .random()))
        modelContext.insert(Item(title: "Oranges", isCompleted: .random()))
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
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            addEssentialFoods()
                        } label: {
                            Label("Add sample items", systemImage: "carrot")
                        }
                    }
                }
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
        Item(title: "Oranges", isCompleted: .random()),
        Item(title: "Oranges", isCompleted: .random()),
    ]

    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for item in sampleData {
        container.mainContext.insert(item)
    }

    return ContentView()
        .modelContainer(container)
}
