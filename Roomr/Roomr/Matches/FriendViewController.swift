//
//  FriendViewController.swift
//  Roomr
//
//  Created by Sophia on 12/5/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class FriendViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var storage: Storage!
    var ref: DatabaseReference!
    var peopleQuery: [People] = []
    
    var friendCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var friendCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendCollection.dataSource = self
        self.friendCollection.delegate = self
        self.storage = Storage.storage()
        self.ref = Database.database().reference()
        self.fetchData(ref)
        self.setupCollectionViewItemSize()
        // Do any additional setup after loading the view.
    }
    private func setupCollectionViewItemSize() {
        if friendCollectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 2
            let interItemSpacing: CGFloat = 1
            
            let width = (self.friendCollection.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            // cell display setting
            friendCollectionViewFlowLayout = UICollectionViewFlowLayout()
            friendCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            friendCollectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            friendCollectionViewFlowLayout.scrollDirection = .vertical
            friendCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
            friendCollectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            self.friendCollection.setCollectionViewLayout(friendCollectionViewFlowLayout, animated: true)
        }
    }
    func fetchData (_ ref: DatabaseReference?) -> Void {
        self.peopleQuery = []
        guard let userID = Auth.auth().currentUser?.uid else {return}
        var allPeople: [People] = []
        
        ref?.child("user").child(userID).child("friends").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }

            for person in snapshot {
                
                let key = person.key
                let name = person.childSnapshot(forPath: "name").value as? String
                let downloadURL = person.childSnapshot(forPath: "imageURL").value as? String
                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date(), url: downloadURL ??  "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png", key:key)
                allPeople.append(people)
                
            }
            DispatchQueue.main.async {
                self.peopleQuery = allPeople
                self.friendCollection.reloadData()
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
        let cell = friendCollection.dequeueReusableCell(withReuseIdentifier: "Friend", for: indexPath as IndexPath) as! FriendCell
        cell.person = person

        return cell
    }


}
