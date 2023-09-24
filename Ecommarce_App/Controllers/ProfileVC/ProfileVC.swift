//
//  ProfileVC.swift
//  E-commerce_App
//
//  Created by Tipu on 24/9/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        
    }

}
