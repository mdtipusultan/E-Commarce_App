//
//  ProductDetailVC.swift
//  Ecommarce_App
//
//  Created by Tipu on 25/9/23.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var itemDetails: UITextView!
    
    // Property to hold the selected product
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        // Check if a product is set
        if let product = product {
            // Display product details
            itemName.text = product.itemName
            itemPrice.text = "\(product.itemPrice)"
            itemDetails.text = product.itemDescription
            
            // Load and display the product image
            if let imageUrl = URL(string: product.itemImage) {
                itemImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
            }
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let product = product {
            // Add the selected product to the cart
            Cart.shared.addItem(product)
          
            // Post the CartUpdated notification
            NotificationCenter.default.post(name: CartVC.cartUpdatedNotification, object: nil)
        }
    }
}
