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
    var currentPage = 1
    let itemsPerPage = 10
    private var isLoading = false
    private var loadingView: UIActivityIndicatorView!
    private var tableViewFooter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize the loading spinner
        loadingView = UIActivityIndicatorView(style: .medium)
        
        // Create a custom footer view for the table view
        tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        tableViewFooter.addSubview(loadingView)
        
        // Center the loading indicator within the footer view
        loadingView.center = CGPoint(x: tableViewFooter.bounds.midX, y: tableViewFooter.bounds.midY)
        
        // Set the table view's footer view
        tableView.tableFooterView = tableViewFooter
        loadNextPage()
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
    
    // MARK: - newData
    private func loadNextPage() {
        // Check if loading is already in progress or there are no more pages to load
        guard !isLoading, let selectedCategory = selectedCategory else { return }
        
        // Set the isLoading flag to true to prevent multiple requests
        isLoading = true
        
        // Show the loading spinner
        loadingView.startAnimating()
        
        // Calculate the range for the next page
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, selectedCategory.items.count)
        
        // Check if there are more items to load
        guard startIndex < endIndex else {
            isLoading = false
            loadingView.stopAnimating() // Stop the loading spinner
            return
        }
        
        // Fetch the next page of products for the selected category
        let nextPageProducts = Array(selectedCategory.items[startIndex..<endIndex])
        
        // Append the new products to the existing products array
        products += nextPageProducts
        
        // Increment the current page
        currentPage += 1
        
        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            // Delay for 2-3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                // Hide the loading spinner
                self.loadingView.stopAnimating()
                
                // Check if there are more items to load
                if endIndex >= selectedCategory.items.count {
                    // All items have been loaded, disable further pagination
                    self.isLoading = true
                } else {
                    // There may be more items to load, allow pagination
                    self.isLoading = false
                }
            }
        }
    }
    // MARK: - scrollDown
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            loadNextPage()
        }
    }
}
