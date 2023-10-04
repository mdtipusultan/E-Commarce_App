//
//  Category.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import Foundation

struct PaginationInfo: Codable {
    let currentPage: Int
    let totalPages: Int
    let itemsPerPage: Int
}

struct Category: Codable {
    let categoryName: String
    let items: [Product]
}

struct Product: Codable {
    let itemName: String
    let itemPrice: Double
    let itemImage: String
    let itemDescription: String

}
