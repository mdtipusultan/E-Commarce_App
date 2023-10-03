//
//  Cart.swift
//  Ecommarce_App
//
//  Created by Tipu on 25/9/23.
//

import Foundation

class Cart {
    static let shared = Cart()
    
    private init() { }
    
    var items: [Product] = []
    
    func addItem(_ product: Product) {
        items.append(product)
       
    }
    
    func removeItem(_ product: Product) {
        if let index = items.firstIndex(where: { $0.itemName == product.itemName }) {
            items.remove(at: index)
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
