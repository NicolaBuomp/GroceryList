//
//  Tip.swift
//  GroceryList
//
//  Created by Nicola Buompane on 28/03/25.
//

import Foundation
import TipKit

struct ButtonTip: Tip {
    var title: Text = Text("Digita")
    var message: Text? = Text("Aggiungi prodotti alla tua lista")
    var image: Image? = Image(systemName: "info.circle")
}
