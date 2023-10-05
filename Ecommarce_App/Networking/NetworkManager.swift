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
    
    func fetchProducts(for category: String, pageNumber: Int, pageSize: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        // Define the Mockaroo API URL for fetching products with pagination
        let apiURL = URL(string: "https://my.api.mockaroo.com/eco.json")!
        
        // Create a URL request with the "X-API-Key" header and query parameters for pagination
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
        ]
        
        var request = URLRequest(url: components.url!)
        request.addValue("a1321210", forHTTPHeaderField: "X-API-Key")
        
        // Create a URLSession data task to fetch the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON data into an array of Product
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    completion(.success(products))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
