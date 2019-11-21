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
    var profile : UserSetupProfile!
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menButton.layer.cornerRadius = 10
        womenButton.layer.cornerRadius = 10
        everyoneButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
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
        button.titleLabel?.textColor = UIColor.white
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupPicsController
        vc?.profile = self.profile
    }
}
