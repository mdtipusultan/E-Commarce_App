//
//  Category.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import Foundation

struct Category: Codable {
    let categoryName: String
    //let itemCount: Int
    let items: [Product]
}

struct Product: Codable {
    let itemName: String
    let itemPrice: Double
    let itemImage: String
    let itemDescription: String
}
