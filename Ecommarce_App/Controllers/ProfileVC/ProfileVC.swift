//
//  ProfileVC.swift
//  E-commerce_App
//
//  Created by Tipu on 24/9/23.
//

import UIKit

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the profilePicture round
        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
        self.profilePicture.clipsToBounds = true
        
        // Add a tap gesture recognizer to the profile picture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGesture)
    }
    
    @objc func profilePictureTapped() {
        // Create and configure the image picker controller
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        // Present the image picker controller
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Handle image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePicture.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.image = originalImage
        }
        
        // Dismiss the image picker controller
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Handle image picker cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
