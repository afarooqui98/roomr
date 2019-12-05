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
    
    @IBAction func cleanlinessSliderChanged(_ sender: UISlider) {
        sender.value = round(sender.value)
        self.profile.cleanliness = Int(round(sender.value))
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        sender.value = round(sender.value)
        self.profile.volume = Int(round(sender.value))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupHousingPrefsController
        vc?.profile = self.profile
    }
}
