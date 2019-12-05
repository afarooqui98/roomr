//
//  AccountSetupPhoneNumebrController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 12/4/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import PhoneNumberKit

class AccountSetupPhoneNumberController: UIViewController {
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var secondaryTitleField: UILabel!
    
    var profile : UserSetupProfile!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 4
        phoneField.becomeFirstResponder()
        
        titleField.adjustsFontSizeToFitWidth = true
        titleField.minimumScaleFactor = 0.2
        
        secondaryTitleField.adjustsFontSizeToFitWidth = true
        secondaryTitleField.minimumScaleFactor = 0.2
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func fillPhoneField(_ sender: Any) {
        self.profile.phoneNumber = phoneField.text ?? ""
    }
    
    // MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if phoneField.text?.isEmpty ?? true || phoneField.text == "" {
            phoneField.placeholder = "Please enter a number before proceeding"
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupAgeController
        vc?.profile = self.profile
    }
}
