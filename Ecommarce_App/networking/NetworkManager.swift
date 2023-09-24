//
//  NetworkManager.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchCategories(completion: @escaping ([Category]?) -> Void) {
        if let path = Bundle.main.path(forResource: "categories", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let categories = try JSONDecoder().decode([Category].self, from: data)
                completion(categories)
            } catch {
                print("Error decoding categories: \(error)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }

    func fetchProducts(for category: String, completion: @escaping ([Product]?) -> Void) {
        // Fetch categories
        fetchCategories { categories in
            if let categories = categories {
                // Find the category with the specified name
                if let foundCategory = categories.first(where: { $0.categoryName == category }) {
                    let products = foundCategory.items
                    completion(products)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

}
