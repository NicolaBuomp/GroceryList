//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Nicola Buompane on 28/03/25.
//

import SwiftUI
import SwiftData

@main
struct GroceryListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
