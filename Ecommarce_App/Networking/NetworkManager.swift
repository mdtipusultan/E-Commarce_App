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
    //for json
    /*
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
     */
    //for api
    
    func fetchCategories(completion: @escaping ([Category]?) -> Void) {
        // Define the Mockaroo API URL
        let apiURL = URL(string: "https://my.api.mockaroo.com/eco.json")!
        
        // Create a URL request with the "X-API-Key" header
        var request = URLRequest(url: apiURL)
        request.addValue("a1321210", forHTTPHeaderField: "X-API-Key")
        
        // Create a URLSession data task to fetch the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON data into an array of Category
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    completion(categories)
                } catch {
                    print("Error decoding categories: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchProducts(for category: String, page: Int, itemsPerPage: Int, completion: @escaping ([Product]?) -> Void) {
        // Fetch categories
        fetchCategories { categories in
            if let categories = categories {
                // Find the category with the specified name
                if let foundCategory = categories.first(where: { $0.categoryName == category }) {
                    let startIndex = (page - 1) * itemsPerPage
                    let endIndex = min(startIndex + itemsPerPage, foundCategory.items.count)
                    
                    // Check if there are more items to load
                    if startIndex >= endIndex {
                        completion(nil) // No more items to load
                        return
                    }
                    
                    let products = Array(foundCategory.items[startIndex..<endIndex])
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
