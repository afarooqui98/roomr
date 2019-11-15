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
    var roomrBlue = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manButton.layer.cornerRadius = 10
        womanButton.layer.cornerRadius = 10
        otherButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectMan(_ sender: Any) {
        setWhite(manButton)
        setBlue(womanButton)
        setBlue(otherButton)
    }
    
    @IBAction func selectWoman(_ sender: Any) {
        setWhite(womanButton)
        setBlue(manButton)
        setBlue(otherButton)
    }
    
    @IBAction func selectOther(_ sender: Any) {
        //MARK: add alert to set custom gender
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
