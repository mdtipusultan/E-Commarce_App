//
//  CartVC.swift
//  E-commerce_App
//
//  Created by Tipu on 24/9/23.
//

import UIKit

class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // Define a notification name
       static let cartUpdatedNotification = Notification.Name("CartUpdated")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        // Update the badge using the count from UserDefaults
        if let cartItemCount = UserDefaults.standard.value(forKey: "CartItemCount") as? Int {
            tabBarController?.tabBar.items?[1].badgeValue = "\(cartItemCount)"
        }
    }

    //MARK: tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        let product = Cart.shared.items[indexPath.row]
        
        // Display product details in the cell (e.g., name, price, image)
        cell.prooductt_Name.text = product.itemName
        cell.prooduct_Price.text = "\(product.itemPrice)"
        
        // Load and display the product image using SDWebImage
         if let imageUrl = URL(string: product.itemImage) {
             cell.prooductImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
         }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
