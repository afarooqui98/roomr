//
//  MatchViewController.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MatchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var storage: Storage!
    var ref: DatabaseReference!
    var peopleInit: [People] = []
    var peopleQuery: [People] = []
    var matchCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var matchCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchCollection.dataSource = self
        self.matchCollection.delegate = self
        
        self.storage = Storage.storage()
        self.ref = Database.database().reference()
        self.fetchData(ref)
        self.setupCollectionViewItemSize()
    }
    

    // MARK: UICollectionViewCell Size
    private func setupCollectionViewItemSize() {
        if matchCollectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 2
            let interItemSpacing: CGFloat = 1
            
            let width = (self.matchCollection.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            // cell display setting
            matchCollectionViewFlowLayout = UICollectionViewFlowLayout()
            matchCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            matchCollectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            matchCollectionViewFlowLayout.scrollDirection = .vertical
            matchCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
            matchCollectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            self.matchCollection.setCollectionViewLayout(matchCollectionViewFlowLayout, animated: true)
        }
    }

    // MARK: import data
    func fetchData (_ ref: DatabaseReference?) -> Void {
        let userID = "90VZVPq028eFEJPCt83PeLFPKem2" // hard code
        var allPeople: [People] = []
        
        ref?.child(userID).child("Contacts").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }

            for person in snapshot {
                let name = person.childSnapshot(forPath: "Name").value as? String
                let downloadURL = person.childSnapshot(forPath: "URL").value as? String
//                let storageRef = self.storage.reference(forURL: downloadURL ??
//                    "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png")
                
//                storageRef.downloadURL { (url, error) in
//                    let data = NSData(contentsOf: url!)
//                    let image = UIImage(data: data! as Data)
//                    let people = People(image: image ?? #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date())
//                }
                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date(), url: downloadURL ??  "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png")
                allPeople.append(people)
            }
            DispatchQueue.main.async {
                self.peopleInit = allPeople
                self.peopleQuery = allPeople
                self.matchCollection.reloadData()
            }
            
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.peopleQuery.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let person = peopleQuery[indexPath.row]
        let cell = matchCollection.dequeueReusableCell(withReuseIdentifier: "Contact", for: indexPath as IndexPath) as! ContactCell
        cell.person = person
        
        // make the image circle
//        cell.ImageView.layer.cornerRadius = (cell.ImageView.frame.size.width ) / 2
//        cell.ImageView.clipsToBounds = true
//        cell.ImageView.layer.borderWidth = 3.0
//        cell.ImageView.layer.borderColor = UIColor.white.cgColor

        return cell
    }


}
