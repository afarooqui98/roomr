//
//  AccountSetupPicsController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase

class AccountSetupPicsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var picsCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    var ref: DatabaseReference!
    
    var profile : UserSetupProfile!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goHome(_ sender: Any) {
//        let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
//        let vc = storyBoard.instantiateViewController(identifier: "homeViewController")
//        let home = vc as! HomeViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(home, animated: true, completion: {})
        let key = ref.child("user").child(Auth.auth().currentUser?.uid ?? "invalid_user")
        let df = DateFormatter()
        df.dateFormat = "mm-dd-yyyy"
        let post = [
            "firstName" : profile.firstName,
            "dob" : df.string(from: profile.DOB),
            "gender" : profile.gender,
            "genderpref" : profile.genderPref
        ]
        
        key.setValue(post)
    }
    
    //MARK: datasource implementation
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picsCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
//        cell.contentView.addSubview(<#T##view: UIView##UIView#>)
        return cell
    }
}
