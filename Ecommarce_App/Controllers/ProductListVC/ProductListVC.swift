//
//  ProductListVC.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import UIKit
import SDWebImage

class ProductListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: Category?
    var products: [Product] = []
    
    var currentPage: Int = 1
    var totalPages: Int = 1 // Calculate this based on your data
    var itemsPerPage: Int = 10
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadProducts()
     }
     
     // Load products from the API
    func loadProducts() {
         guard !isLoading else {
             return // Don't load more data if a request is already in progress
         }
         
         isLoading = true
         
         NetworkManager.shared.fetchProducts(for: selectedCategory?.categoryName ?? "", page: currentPage, perPage: itemsPerPage) { [weak self] paginationInfo, response in
             DispatchQueue.main.async {
                 self?.isLoading = false
                 
                 if let paginationInfo = paginationInfo {
                     // Extract pagination information
                     self?.currentPage = paginationInfo.currentPage
                     self?.totalPages = paginationInfo.totalPages
                     self?.itemsPerPage = paginationInfo.itemsPerPage
                 }
                 
                 if let response = response {
                     // Append the new products to your existing array
                     self?.products += response
                     self?.tableView.reloadData()
                 }
             }
         }
     }

    // Implement UITableViewDelegate's scrollViewDidScroll to load more products when scrolling to the end
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // User has scrolled to the end, load more products if available
            if currentPage < totalPages {
                currentPage += 1
                loadProducts()
            }
        }
    }


    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(products.count)
        // Check if the selected category exists and has items
        if let selectedCategory = selectedCategory, !selectedCategory.items.isEmpty {
            // Return the number of items in the selected category
            return selectedCategory.items.count
        } else {
            // If no items or selectedCategory is nil, return 0 rows
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! productListTableViewCell
        
        // Check if the selected category exists and has items
        if let selectedCategory = selectedCategory, !selectedCategory.items.isEmpty {
            let product = selectedCategory.items[indexPath.row]
            
            // Use SDWebImage to load and set the product image
            if let imageUrl = URL(string: product.itemImage) {
                cell.productImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the selected category exists and has items
        guard let selectedCategory = selectedCategory, !selectedCategory.items.isEmpty else {
            return
        }
        
        // Get the selected product
        let selectedProduct = selectedCategory.items[indexPath.row]
        
        // Create an instance of ProductDetailVC from the storyboard
        if let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
            // Pass the selected product to ProductDetailVC
            productDetailVC.product = selectedProduct
            
            // Push or present ProductDetailVC
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }

}
