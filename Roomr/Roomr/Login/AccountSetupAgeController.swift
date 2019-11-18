//
//  AccountSetupAgeController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import DateTextField

class AccountSetupAgeController: UIViewController {
    @IBOutlet weak var ageField: DateTextField!
    @IBOutlet weak var nextButton: UIButton!
    var profile : UserSetupProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10
        ageField.becomeFirstResponder()
        ageField.dateFormat = .monthDayYear
        ageField.separator = "/"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fillDate(_ sender: Any) {
        if let date = ageField.date {
            profile.DOB = date
        } else {
            print("error parsing")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let _ = ageField.date {
            return true
        }
        
        ageField.placeholder = "Please fill out with format mm/dd/yyyy"
        return false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupGenderController
        vc?.profile = self.profile
    }
}
