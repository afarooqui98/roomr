//
//  AccountSetupGenderPrefController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupGenderPrefController: UIViewController {
    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var everyoneButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    var profile : UserSetupProfile!
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menButton.layer.cornerRadius = 4
        womenButton.layer.cornerRadius = 4
        everyoneButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        secondaryTitleLabel.adjustsFontSizeToFitWidth = true
        secondaryTitleLabel.minimumScaleFactor = 0.2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectMen(_ sender: Any) {
        setWhite(menButton)
        setBlue(womenButton)
        setBlue(everyoneButton)
        
        profile.genderPref = "Men"
    }
    
    @IBAction func selectWomen(_ sender: Any) {
        setWhite(womenButton)
        setBlue(menButton)
        setBlue(everyoneButton)
        
        profile.genderPref = "Women"
    }
    
    @IBAction func selectEveryone(_ sender: Any) {
        setWhite(everyoneButton)
        setBlue(menButton)
        setBlue(womenButton)
        
        profile.genderPref = "Everyone"
    }
    
    func setWhite(_ button: UIButton){
        button.backgroundColor = UIColor.white
        button.setTitleColor(roomrBlue, for: .normal)
        button.layer.borderColor = roomrBlue.cgColor
        button.layer.borderWidth = 1
    }
    
    func setBlue(_ button : UIButton){
        button.backgroundColor = roomrBlue
        button.setTitleColor(.white, for: .normal)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupMorePrefsController
        vc?.profile = self.profile
    }
}
