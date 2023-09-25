//
//  HomeVC.swift
//  E-commerce_App
//
//  Created by Tipu on 24/9/23.
//
import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchCategories()
        
        // Configure UICollectionViewFlowLayout
        configureCollectionViewLayout()
    }
    
    //MARK: Fetch categories using NetworkManager
    func fetchCategories(){
        NetworkManager.shared.fetchCategories { [weak self] categories in
            guard let categories = categories else { return }
            
            self?.categories = categories
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Set up the UICollectionViewFlowLayout
    func configureCollectionViewLayout(){
        
        // Set up the UICollectionViewFlowLayout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth - 30) / 2 // Two cells in a row with spacing of 10
            let cellHeight = cellWidth
            
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.minimumLineSpacing = 10 // Adjust the spacing between rows
            layout.minimumInteritemSpacing = 10 // Adjust the spacing between cells in the same row
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
        cell.categoryNumber.text = "Items: \(category.items.count)"
        return cell
    }
    
    // Handle category cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = categories[indexPath.item]
        
        let productListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
        productListVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(productListVC, animated: true)
    }

    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the cell size based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 70) / 2
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
