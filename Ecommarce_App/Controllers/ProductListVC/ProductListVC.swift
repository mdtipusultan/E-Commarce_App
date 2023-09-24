//
//  ProductListVC.swift
//  Ecommarce_App
//
//  Created by Tipu on 24/9/23.
//

import UIKit

class ProductListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: Category?
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Fetch products for the selected category using selectedCategory data
        fetchProducts()
    }
    
    func fetchProducts() {
        guard let selectedCategory = selectedCategory else { return }
        
        // Fetch products for the selected category using NetworkManager
        NetworkManager.shared.fetchProducts(for: selectedCategory.categoryName) { [weak self] products in
            guard let products = products else { return }
            
            self?.products = products
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          print(products.count)
          return products.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! productListTableViewCell
          
          let product = products[indexPath.row]
          
          cell.productImage.image = URL(string: product.itemImage)
          // Configure the cell with product data
          //cell.productNameLabel.text = product.itemName
          //cell.productPriceLabel.text = "$\(product.itemPrice)"
          //cell.productDescriptionLabel.text = product.itemDescription
          
          // Load product image (you can use a library like SDWebImage to handle image loading)
          // Example: cell.productImageView.sd_setImage(with: URL(string: product.itemImage), placeholderImage: UIImage(named: "placeholder"))
          
          return cell
      }

}
