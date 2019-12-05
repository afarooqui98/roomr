//
//  AddMediaViewController.swift
//  Roomr
//
//  Created by Ryan Chan on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase

class AddMediaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var picsCollectionView: UICollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var ref: Storage!
    var imgs: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picsCollectionView.delegate = self
        picsCollectionView.dataSource = self
        self.setupCollectionViewItemSize()
        self.populateImages()
        // Do any additional setup after loading the view.
    }
    
    func populateImages(){
        let key = Auth.auth().currentUser?.uid ?? "invalid_user"
        let user_folderURL = "gs://roomr-ecee8.appspot.com/" + key + "/"
        let imageStorageRef = Storage.storage().reference(forURL: user_folderURL)
        imageStorageRef.listAll { (result, error) in
            if let error = error {
                print("error listing user images \(error)")
                
            }
            
            for item in result.items {
                // The items under storageReference.
                item.getData(maxSize: 2 * 1024 * 1024, completion:{ (data,error) in
                    if let error = error {
                        print("Error in downloading image \(error)")
                        
                    } else {
                        if let imageData = data, let image = UIImage(data: imageData) {
                            self.imgs.append(image)
                        }
                    }
                    DispatchQueue.main.async {
                        self.picsCollectionView.reloadData()
                    }
                })
            }
        }
    }
    
    func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 3
            let lineSpacing: CGFloat = 5
            let interItemSpacing: CGFloat = 2
            
            let width = (self.picsCollectionView.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            self.picsCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picsCollectionViewCell", for: indexPath)
        cell.backgroundColor = .white
        
        if imgs.indices.contains(indexPath.row){
            let img = UIImageView(image: imgs[indexPath.row])
            img.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(img)
            img.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4).isActive = true
            img.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4).isActive = true
            img.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4).isActive = true
            img.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4).isActive = true
            img.contentMode = .scaleToFill
            img.layer.masksToBounds = true
        }
        
        return cell
    }

}
