//
//  AccountSetupGenderController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupGenderController: UIViewController {
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    var profile : UserSetupProfile!
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manButton.layer.cornerRadius = 4
        womanButton.layer.cornerRadius = 4
        otherButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        secondaryTitleLabel.adjustsFontSizeToFitWidth = true
        secondaryTitleLabel.minimumScaleFactor = 0.2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectMan(_ sender: Any) {
        setWhite(manButton)
        setBlue(womanButton)
        setBlue(otherButton)
        
        profile.gender = "Man"
    }
    
    @IBAction func selectWoman(_ sender: Any) {
        setWhite(womanButton)
        setBlue(manButton)
        setBlue(otherButton)
        
        profile.gender = "Woman"
    }
    
    @IBAction func selectOther(_ sender: Any) {
        //MARK: add alert to set custom gender
    }
    
    func setWhite(_ button: UIButton){
        button.backgroundColor = UIColor.white
        button.layer.borderColor = roomrBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(roomrBlue, for: .normal)
    }
    
    func setBlue(_ button : UIButton){
        button.backgroundColor = roomrBlue
        button.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupGenderPrefController
        vc?.profile = self.profile
    }
}
