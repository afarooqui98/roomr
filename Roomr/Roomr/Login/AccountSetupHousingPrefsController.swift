//
//  AccountSetupHousingPrefsController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/24/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupHousingPrefsController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    @IBOutlet weak var roommateButton: UIButton!
    @IBOutlet weak var apartmentButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    var profile: UserSetupProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        secondaryTitleLabel.adjustsFontSizeToFitWidth = true
        secondaryTitleLabel.minimumScaleFactor = 0.2
        
        roommateButton.layer.cornerRadius = 4
        apartmentButton.layer.cornerRadius = 4
        bothButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderColor = roomrBlue.cgColor
        nextButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectRoommate(_ sender: Any) {
        profile.housingPref = 1
        setWhite(roommateButton)
        setBlue(apartmentButton)
        setBlue(bothButton)
    }
    
    @IBAction func selectApartment(_ sender: Any) {
        profile.housingPref = 2
        setWhite(apartmentButton)
        setBlue(roommateButton)
        setBlue(bothButton)
    }
    
    @IBAction func selectBoth(_ sender: Any) {
        profile.housingPref = 3
        setWhite(bothButton)
        setBlue(roommateButton)
        setBlue(apartmentButton)
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if profile.housingPref == 0{
            //MARK: add inidication of error case
            return false
        }
        
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AccountSetupPicsController
        vc?.profile = self.profile
    }
}
