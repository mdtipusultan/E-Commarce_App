//
//  CartTableViewCell.swift
//  Ecommarce_App
//
//  Created by Tipu on 25/9/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prooductImage: UIImageView!
    
    @IBOutlet weak var prooductt_Name: UILabel!
    
    @IBOutlet weak var prooduct_Price: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
