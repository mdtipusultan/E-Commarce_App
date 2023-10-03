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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
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
