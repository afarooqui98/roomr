//
//  SettingsViewController.swift
//  Roomr
//
//  Created by Ryan on 11/17/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import SideMenuSwift

class SettingsViewController: UITableViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var genderPref: UISegmentedControl!
    @IBOutlet weak var cleanliness: UISlider!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var phoneField: UITextField!
    var uid = ""
    
    @IBAction func genderPrefChanged(_ sender: UISegmentedControl) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).child("genderpref").setValue(sender.selectedSegmentIndex) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Gender pref could not be saved: \(error).")
          } else {
            print("Gender pref saved successfully!")
          }
        }
    }
    
    @IBAction func cleanChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).child("cleanliness").setValue(roundedValue) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Cleanliness could not be saved: \(error).")
          } else {
            print("Cleanliness saved successfully!")
          }
        }
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).child("volume").setValue(roundedValue) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Volume could not be saved: \(error).")
          } else {
            print("Volume saved successfully!")
          }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize all values from database
        
        //Make this current user
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.setData(snapshot)
        })
        
    }
    
    func setData(_ snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: Any] {
            //Initialize all values from database
            phoneField.text = value["phone"] as? String ?? ""
            genderPref.selectedSegmentIndex =  value["genderpref"] as? Int ?? 2
            cleanliness.value = Float(value["cleanliness"] as? Int ?? 2)
            volume.value = Float(value["volume"] as? Int ?? 2)
            
            
        } else{
            print("Error: No snapshot")
        }
        return
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        let phoneNum = phoneField.text ?? ""
        ref.child("user").child(uid).child("phone").setValue(phoneNum) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Phone num could not be saved: \(error).")
          } else {
            print("Phone num saved successfully!")
          }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white

    }
    
    @IBAction func hamburger_pressed(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }

}
