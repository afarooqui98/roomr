//
//  ProfileViewController.swift
//  Roomr
//
//  Created by Ryan Chan on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import SideMenuSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    var tablevc: ProfileTableViewController?
    var ref: DatabaseReference!
    
    @IBAction func editButton(_ sender: UIButton) {
        //Segue to edit screen
        performSegue(withIdentifier: "EditProfileSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch data from firebase
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.setData(snapshot)
        })
        
        
        //UI prep
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0)/2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        profileImage.clipsToBounds = true
        view.sendSubviewToBack(separator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fetch data from firebase
                let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
                ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    self.setData(snapshot)
                })
    }
    
    
    func setData(_ snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: Any] {
            //Load image
            let uid = Auth.auth().currentUser?.uid ?? ""
            let user_folderURL = "gs://roomr-ecee8.appspot.com/" + uid + "/"            
            let imageStorageRef = Storage.storage().reference(forURL: user_folderURL)
            
            imageStorageRef.listAll { (result, error) in
                if let error = error {
                    print("error listing user images \(error)")
                }
                if result.items.indices.contains(0){
                    result.items[0].getData(maxSize: 2 * 1024 * 1024, completion: { (data,error) in
                        if let error = error {
                            print("Error in downloading image \(error)")
                        } else {
                            if let imageData = data, let image = UIImage(data: imageData) {
                                self.profileImage.image = image
                            }
                        }
                    })
                } else {
                    print("no images found in the profile")
                }
            }
            
            //Load labels
            tablevc?.bioLabel.text = value["bio"] as? String ?? ""
            
            nameLabel.text = value["firstName"] as? String ?? ""
            //Load subview labels
            tablevc?.genderLabel.text = value["gender"] as? String ?? ""
            
            if let ageNum:Int = calculateAge(birthdate: (value["dob"] as? String ?? "")){
                tablevc?.ageLabel.text = String(ageNum)
            }
            
            let housingNum:Int = value["housingpref"] as? Int ?? 0
            if (housingNum == 1){
                tablevc?.housingLabel.text = "Yes"
            } else{
                if (housingNum == 2){
                    tablevc?.housingLabel.text = "No"
                } else{
                    tablevc?.housingLabel.text = "Error"
                }
            }
        } else{
            print("Error: No snapshot")
        }
        return
    }
    

    @IBAction func hamburger_pressed(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
    func calculateAge(birthdate: String) -> Int? {
        let current_year = Calendar.current.component(.year, from: Date())
        
        //Birthday string formatted as: xx-xx-xxxx,
        //Make substring containing only the year
        if let birth_year = Int(birthdate.dropFirst(6)){
            return current_year - birth_year
        } else{
            return nil
        }
    }
    
    @IBAction func unwindController(segue: UIStoryboardSegue) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    self.setData(snapshot)
                })
                
//        dismiss(animated: true, completion: nil)
    }
    
//Scene Delegate testing code
//guard let windowScene = (scene as? UIWindowScene) else { return }
//let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//let vc = storyboard.instantiateViewController(identifier: "TabController")
//self.window?.windowScene = windowScene
//self.window?.rootViewController = vc


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SubviewSegue"){
            if let tablevc = segue.destination as? ProfileTableViewController {
                self.tablevc = tablevc
            }
        }
    }
}
