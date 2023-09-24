//
//  HomeVC.swift
//  E-commerce_App
//
//  Created by Tipu on 24/9/23.
//
import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

       fetchCategories()
    }
    // Fetch categories using NetworkManager
    func fetchCategories(){
        NetworkManager.shared.fetchCategories { [weak self] categories in
            guard let categories = categories else { return }

            self?.categories = categories
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
//MARK: COLLECTTTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categories.count)
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        cell.categoryName.text = category.categoryName
        cell.categoryNumber.text = "Items: \(category.itemCount)"
        return cell
    }
}
