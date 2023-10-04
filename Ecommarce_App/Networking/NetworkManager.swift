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
    // Define the Mockaroo API URL
    func fetchCategories(completion: @escaping ([Category]?) -> Void) {
        // Define the API endpoint URL
        let apiURL = URL(string: "https://my.api.mockaroo.com/ecomarce_app.json")!
        
        // Create a URL request with the "X-API-Key" header
        var request = URLRequest(url: apiURL)
        request.addValue("ba8ba140", forHTTPHeaderField: "X-API-Key")
        
        // Create a URLSession data task to fetch the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                // Print the raw JSON data (as a string)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON data:\n\(jsonString)")
                } else {
                    print("Failed to convert data to JSON string")
                }
                
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


    func fetchProducts(for category: String, page: Int, perPage: Int, completion: @escaping (PaginationInfo?, [Product]?) -> Void) {
        // Define the Mockaroo API URL with query parameters for pagination
        let apiURL = URL(string: "https://my.api.mockaroo.com/ecomarce_app.json?page=\(page)&per_page=\(perPage)")!
        
        // Create a URL request with the "X-API-Key" header
        var request = URLRequest(url: apiURL)
        request.addValue("ba8ba140", forHTTPHeaderField: "X-API-Key")
        
        // Create a URLSession data task to fetch the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil, nil)
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON data into an array of Product
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    
                    // Extract pagination information from the response headers or body if available
                    if let httpResponse = response as? HTTPURLResponse {
                        let paginationInfo = PaginationInfo(
                            currentPage: page,
                            totalPages: httpResponse.allHeaderFields["X-Total-Pages"] as? Int ?? 1,
                            itemsPerPage: perPage
                        )
                        completion(paginationInfo, products)
                    } else {
                        // If pagination info is not available in the response, set it to nil
                        let paginationInfo: PaginationInfo? = nil
                        completion(paginationInfo, products)
                    }
                } catch {
                    print("Error decoding products: \(error)")
                    completion(nil, nil)
                }
            }
        }.resume()
    }



}
