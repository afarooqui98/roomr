//
//  AccountSetupMorePrefsController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/23/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupMorePrefsController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    @IBOutlet weak var cleanlinessSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var nextButton: UIButton!
    var profile: UserSetupProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        secondaryTitleLabel.adjustsFontSizeToFitWidth = true
        secondaryTitleLabel.minimumScaleFactor = 0.2
        
        nextButton.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if profile.cleanliness == 0 || profile.volume == 0{
//            return false
//        }
//
//        return true
//    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupHousingPrefsController
        profile.cleanliness = cleanlinessSlider.value
        profile.volume = volumeSlider.value
        vc?.profile = self.profile
    }
}
