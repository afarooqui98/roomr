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
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menButton.layer.cornerRadius = 10
        womenButton.layer.cornerRadius = 10
        everyoneButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectMen(_ sender: Any) {
        setWhite(menButton)
        setBlue(womenButton)
        setBlue(everyoneButton)
    }
    
    @IBAction func selectWomen(_ sender: Any) {
        setWhite(womenButton)
        setBlue(menButton)
        setBlue(everyoneButton)
    }
    
    @IBAction func selectEveryone(_ sender: Any) {
        setWhite(everyoneButton)
        setBlue(menButton)
        setBlue(womenButton)
    }
    
    func setWhite(_ button: UIButton){
        button.backgroundColor = UIColor.white
        button.titleLabel?.textColor = roomrBlue
        button.layer.borderColor = roomrBlue.cgColor
        button.layer.borderWidth = 1
    }
    
    func setBlue(_ button : UIButton){
        button.backgroundColor = roomrBlue
        button.titleLabel?.textColor = UIColor.white
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
