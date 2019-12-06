//
//  EditProfileTableViewController.swift
//  Roomr
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var genderSegControl: UISegmentedControl!
    @IBOutlet weak var housingSegControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    var profilevc: ProfileViewController?
    var gender_string: String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.setData(snapshot)
        })
        
        
    }
    
    func setData(_ snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: Any] {
            //Initialize data
            nameField.text = value["firstName"] as? String ?? ""
            let genderString = value["gender"] as? String ?? ""
            var genderNum = 2
            switch genderString{
            case "Man":
                genderNum = 0
            case "Woman":
                genderNum = 1
            default:
                genderNum = 2
            }
            genderSegControl.selectedSegmentIndex =  genderNum
            let dateString = value["dob"] as? String ?? "1-1-1998"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm-dd-yyyy"
            datePicker.date = dateFormatter.date(from: dateString) ?? Date()
            housingSegControl.selectedSegmentIndex = value["housing"] as? Int ?? 0
            bioView.text = value["bio"] as? String ?? ""
            
        } else{
            print("Error: No snapshot")
        }
        return
    }
    
    /*
    //Implement in future
    func loadAlert(){
        let alertController = UIAlertController(title: "Please Enter the Gender you Most Closely Identify with:" , message: "", preferredStyle: .alert)
        alertController.addTextField {(textField : UITextField!) -> Void in
            textField.keyboardType = .alphabet
        }
        
        let okAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            if let field = alertController.textFields?[0], let str = field.text{
                self.gender_string = str
            }
        })
        
        //alert action to cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    */

    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        switch sender.selectedSegmentIndex{
        case 0:
            gender_string = "Man"
        case 1:
            gender_string = "Woman"
        case 2:
            gender_string = "Other"
        default:
            gender_string = "invalid_gender"
        }
        ref.child("user").child(uid).child("gender").setValue(gender_string) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Gender could not be saved: \(error).")
          } else {
            print("Gender saved successfully!")
          }
        }
    }
    
    @IBAction func dobChanged(_ sender: Any) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        let dobDate = dateFormatter.string(from: datePicker.date)
        ref.child("user").child(uid).child("dob").setValue(dobDate) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Date of birth could not be saved: \(error).")
          } else {
            print("Date of birth saved successfully!")
          }
        }
    }
    
    @IBAction func housingPrefChanged(_ sender: UISegmentedControl) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        ref.child("user").child(uid).child("housingpref").setValue(sender.selectedSegmentIndex + 1) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Housing pref could not be saved: \(error).")
          } else {
            print("Housing pref saved successfully!")
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? ""
        let name = nameField.text ?? ""
        ref.child("user").child(uid).child("firstName").setValue(name) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Name could not be saved: \(error).")
          } else {
            print("Name saved successfully!")
          }
        }
        
        let bio = bioView.text ?? ""
        ref.child("user").child(uid).child("bio").setValue(bio) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Bio could not be saved: \(error).")
          } else {
            print("Bio saved successfully!")
          }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ProfileViewController {
            controller.nameLabel.text = self.nameField.text
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid ?? ""
            let name = self.nameField.text ?? ""
            ref.child("user").child(uid).child("firstName").setValue(name) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Name could not be saved: \(error).")
              } else {
                print("Name saved successfully!")
              }
            }
            
            let bio = self.bioView.text ?? ""
            ref.child("user").child(uid).child("bio").setValue(bio) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Bio could not be saved: \(error).")
              } else {
                print("Bio saved successfully!")
              }
            }
                    ref.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        controller.setData(snapshot)
            })
        }
    }

}
