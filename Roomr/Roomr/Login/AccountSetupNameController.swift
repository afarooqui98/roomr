//
//  AccountSetupNameController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupNameController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleField: UILabel!
    var profile : UserSetupProfile = UserSetupProfile.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 4
        nameField.becomeFirstResponder()
        
        titleField.adjustsFontSizeToFitWidth = true
        titleField.minimumScaleFactor = 0.2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func fillName(_ sender: Any) {
        profile.firstName = nameField.text ?? ""
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if nameField.text?.isEmpty ?? true || nameField.text == "" {
            nameField.placeholder = "Please fill out a name before proceeding"
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupPhoneNumberController
        vc?.profile = self.profile
    }
}
