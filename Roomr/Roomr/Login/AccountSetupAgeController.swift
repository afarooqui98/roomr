//
//  AccountSetupAgeController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupAgeController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    var profile : UserSetupProfile!
    var youngestDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 4
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        secondaryTitleLabel.adjustsFontSizeToFitWidth = true
        secondaryTitleLabel.minimumScaleFactor = 0.2
        
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.minimumScaleFactor = 0.2

        
        //MARK: set a minimum date to check for 18 and older
        // Do any additional setup after loading the view.
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //MARK: uncomment this stuff later
//        if datePicker.date >= youngestDate {
            profile.DOB = datePicker.date
            return true
//        }
        
//        errorLabel.text = "Please enter a date that is 18 years or older"
//        return false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupGenderController
        vc?.profile = self.profile
    }
}
