//
//  AccountSetupAgeController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class AccountSetupAgeController: UIViewController {
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10
        ageField.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
