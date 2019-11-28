//
//  MatchViewController.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase

class MatchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    var ref: DatabaseReference!
    var peopleInit: [People] = []
    var peopleQuery: [People] = []
    var matchCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var matchCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchCollection.dataSource = self
        self.matchCollection.delegate = self
        var allPeople: [People] = []
        self.ref = Database.database().reference()
        let userID = "90VZVPq028eFEJPCt83PeLFPKem2"

        ref?.child(userID).child("Contacts").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }

            for person in snapshot {
                let name = person.childSnapshot(forPath: "Name").value as? String
                 print("Name here ",name)
                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date())

                allPeople.append(people)
            }
            self.peopleInit = allPeople
            self.peopleQuery = allPeople
            print("hererere !!!!!",self.peopleInit)
            
            self.matchCollection.reloadData()
            
        }){(error) in
            print(error.localizedDescription)

        }
    
        self.setupCollectionViewItemSize()
//        self.peopleQuery = self.fetchData(ref)

//        self.matchCollection.reloadData()

    }
//    override func viewWillLayoutSubviews() {
//         super.viewWillLayoutSubviews()
//         setupCollectionViewItemSize()
//     }
//    // MARK: fetch data
//    func fetchData(_ ref: DatabaseReference) -> [People] {
//        var allPeople: [People] = []
//        let userID = "90VZVPq028eFEJPCt83PeLFPKem2"
//        ref.child(userID).child("Contacts").observe(DataEventType.value, with: { (snapshot) in
//                      guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                          else { return }
//
//                      for person in snapshot {
//                          let name = person.childSnapshot(forPath: "Name").value as? String
//                           print("Name here ", name)
//                          let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date())
//
//                          allPeople.append(people)
//                      }
//
//                  }){(error) in
//                      print(error.localizedDescription)
//
//                  }
//        return allPeople
//
//    }
    // MARK: import data
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       print(self.peopleQuery.count)
       return self.peopleQuery.count
    }
    


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let person = peopleQuery[indexPath.row]
        let cell = matchCollection.dequeueReusableCell(withReuseIdentifier: "Contact", for: indexPath as IndexPath) as! ContactCell
        cell.setContact(profile: person)
        cell.ImageView.layer.cornerRadius = (cell.ImageView.frame.size.width ?? 0.0) / 2
        cell.ImageView.clipsToBounds = true
        cell.ImageView.layer.borderWidth = 3.0
        cell.ImageView.layer.borderColor = UIColor.white.cgColor

        return cell
    }
    
    // MARK: UICollectionViewCell Size
    private func setupCollectionViewItemSize() {
        if matchCollectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 2
            let interItemSpacing: CGFloat = 2
            
            let width = (self.matchCollection.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            
            matchCollectionViewFlowLayout = UICollectionViewFlowLayout()
            matchCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            matchCollectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            matchCollectionViewFlowLayout.scrollDirection = .vertical
            matchCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
            matchCollectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            self.matchCollection.setCollectionViewLayout(matchCollectionViewFlowLayout, animated: true)
        }
    }



}
