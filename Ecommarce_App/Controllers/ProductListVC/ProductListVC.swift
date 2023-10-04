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
       var pageNumber = 1
       var pageSize = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchFirstTenData()
                
        print(selectedCategory?.categoryName as Any)
        // Load the first page of products
              loadProducts()
        print(selectedCategory?.categoryName as Any)
     }
    func fetchFirstTenData(){
        // Check if a category is selected
        if let selectedCategory = selectedCategory {
            // Assuming that the "items" array in the selectedCategory contains all products,
            // you can slice it to get the first 10 items.
            let startIndex = (pageNumber - 1) * pageSize
            let endIndex = min(startIndex + pageSize, selectedCategory.items.count)
            
            if startIndex < endIndex {
                products = Array(selectedCategory.items[startIndex..<endIndex])
            } else {
                products = []
            }
        }
        
        print(products)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(products.count)
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! productListTableViewCell
        
        let product = products[indexPath.row]
               
               // Use SDWebImage to load and set the product image
               if let imageUrl = URL(string: product.itemImage) {
                   cell.productImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
               }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard indexPath.row < products.count else {
              return
          }
          
          // Get the selected product
          let selectedProduct = products[indexPath.row]
          
          // Create an instance of ProductDetailVC from the storyboard
          if let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
              // Pass the selected product to ProductDetailVC
              productDetailVC.product = selectedProduct
              
              // Push or present ProductDetailVC
              navigationController?.pushViewController(productDetailVC, animated: true)
          }
      }
    
    //MARK: LOAD-PRODUCTS
    func loadProducts() {
        guard let selectedCategory = selectedCategory else {
            return
        }
        
        // Fetch products for the selected category with pagination
        NetworkManager.shared.fetchProducts(for: selectedCategory.categoryName, pageNumber: pageNumber, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let products):
                // Append the new products to the existing products array
                self?.products.append(contentsOf: products)
                
                // Refresh the table view on the main thread
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
                // Increment the page number for the next request
                self?.pageNumber += 1
                
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }

        
        // Load more products when reaching the end of the table view
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let screenHeight = scrollView.frame.size.height
            
            if offsetY > contentHeight - screenHeight {
                // Reached the end of the table view, load more products
                loadProducts()
            }
        }

}
