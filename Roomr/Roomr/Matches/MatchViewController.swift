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
    var peopleQuery: [People] = []
    var matchCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var refreshingData = false
    
    @IBOutlet weak var matchCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchCollection.dataSource = self
        self.matchCollection.delegate = self
        
        self.storage = Storage.storage()
        self.ref = Database.database().reference()
        self.fetchData(ref)
        self.setupCollectionViewItemSize()
//        self.createMatches()
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
        self.peopleQuery = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var allPeople: [People] = []
        
        ref?.child("user").child(userID).child("matches").observe(DataEventType.value, with: { (snapshot) in
            self.refreshingData = true
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }

            for person in snapshot {
                let isFriend = person.childSnapshot(forPath: "isFriend").value as! Bool
                if isFriend == false {
                    let key = person.key
                    let name = person.childSnapshot(forPath: "name").value as? String
                    let downloadURL = person.childSnapshot(forPath: "imageURL").value as? String
                    let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date(), url: downloadURL ??  "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png", key:key)
                    allPeople.append(people)
                }
            }
            self.refreshingData = false
            DispatchQueue.main.async {
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

        return cell
    }
    


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = peopleQuery[indexPath.row]
        
        //if (!refreshingData) {
            loadAlert(person, index:indexPath)
        //}
        // cur user want to talk person.id
    }
    
    func loadAlert(_ person: People, index: IndexPath){
        guard let currID = Auth.auth().currentUser?.uid else { return }
        let matches_key = ref?.child("user").child(person.key).child("matches")
        matches_key?.child(currID).observeSingleEvent(of: .value, with: { (snapshot) in
            print(String(describing: snapshot))
            let value = snapshot.value as? NSDictionary
            if let talk = value?["wantToTalk"], let wantToTalk = talk as? Bool {
                if wantToTalk {
                    return
                } else {
                    let alertController = UIAlertController(title: "Are You Sure You Want to Send a Message Request?" , message: "", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
                        //MARK: send notification
                        print("request sent to user \(person.name)")
                        self.matchCollection.deleteItems(at: [index])
                        //set the wantToTalk values
                        self.wantToTalk(person.key)
                    })
                    
                    //alert action to cancel
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        })
    }
    
    func addUserToFriendTable(currentUserRef: DatabaseReference?, userToMove: String, snapshot: DataSnapshot){
        if let friendsTable = currentUserRef?.child("friends").child(userToMove){
            let imageURL = snapshot.childSnapshot(forPath: "imageURL").value as! String
            let name = snapshot.childSnapshot(forPath: "name").value as! String
            let userPost = [
                "imageURL": imageURL,
                "name": name
            ] as [String : Any]
            friendsTable.setValue(userPost)
        }
        
        if let matchesTable = currentUserRef?.child("matches").child(userToMove){
            matchesTable.updateChildValues(["isFriend": true])
        }
    }
    
//    func createMatches(){
//        guard let currID  = Auth.auth().currentUser?.uid else { return }
//        let userToMove = "1D91042E-7EA6-4C56-A55C-49EC5FBDF235"
//
//        if let matchesTable1 = self.ref?.child("user").child(currID).child("matches").child(userToMove){
//            let userPost = [
//                "imageURL": "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png",
//                "name": "Sophia",
//                "wantToTalk":true,
//                "isFriend":false
//            ] as [String : Any]
//            matchesTable1.setValue(userPost)
//        }
//
//        if let matchesTable2 = self.ref?.child("user").child(userToMove).child("matches").child(currID){
//            let userPost = [
//                "imageURL": "gs://roomr-ecee8.appspot.com/mOgPHxdnz7N9aQ5fOrlFS2sDoD92/image7.png",
//                "name": "Ahmed",
//                "wantToTalk":false,
//                "isFriend":false
//            ] as [String : Any]
//            matchesTable2.setValue(userPost)
//        }
//
//    }

    func wantToTalk(_ personID: String){
        // check my own mathces list
        guard let currID = Auth.auth().currentUser?.uid else {return}

        let currentKey = self.ref?.child("user").child(currID)
        let targetKey = self.ref?.child("user").child(personID)
        currentKey?.child("matches").child(personID).observe(DataEventType.value, with: { (snapshot) in
            //target user's snapshot
            let wantToTalk = snapshot.childSnapshot(forPath: "wantToTalk").value as! Bool
            if wantToTalk == true{ //user already wants to be friends with you, immediately move to friends table
                //move target user to current users friend table
                self.addUserToFriendTable(currentUserRef: currentKey, userToMove: personID, snapshot: snapshot)
                    
                //move current user data to target user's friend table
                targetKey?.child("matches").child(currID).observe(DataEventType.value, with: {(currSnapshot) in
                    self.addUserToFriendTable(currentUserRef: targetKey, userToMove: currID, snapshot: currSnapshot)
                })
            } else{
                //go to target user, find current user, set wantToTalk to true
                targetKey?.child("matches").child(currID).updateChildValues(["wantToTalk": true])
            }
            
            self.fetchData(self.ref)
         }){(error) in
             print(error.localizedDescription)
         }
    }
}
