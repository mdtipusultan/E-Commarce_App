//
//  Category.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import Foundation

struct Category: Codable {
    let categoryName: String
    let itemCount: Int
    let rowNumber: Int
    let pageSize: Int
    let pageNumberField: Int
    let items: [Product]

    // Define a custom initializer to handle nested JSON structure
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryName = try container.decode(String.self, forKey: .categoryName)
        itemCount = try container.decode(Int.self, forKey: .itemCount)
        rowNumber = try container.decode(Int.self, forKey: .rowNumber)
        pageSize = try container.decode(Int.self, forKey: .pageSize)
        pageNumberField = try container.decode(Int.self, forKey: .pageNumberField)
        
        // Decode the nested "items" array
        var itemsContainer = try container.nestedUnkeyedContainer(forKey: .items)
        var products: [Product] = []

        while !itemsContainer.isAtEnd {
            let product = try itemsContainer.decode(Product.self)
            products.append(product)
        }

        items = products
    }
}


struct Product: Codable {
    let itemName: String
    let itemPrice: Double
    let itemImage: String
    let itemDescription: String
}
